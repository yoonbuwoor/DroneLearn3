import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/remote_content_models.dart';
import '../services/background_update_service.dart';
import '../services/content_update_service.dart';
import '../services/notification_service.dart';

class AppController extends ChangeNotifier {
  AppController();

  static const String _notificationsEnabledKey = 'notifications.enabled';
  static const String _reminderFrequencyKey = 'notifications.reminderFrequency';

  final Set<String> _completedLessons = <String>{};
  final Set<String> _completedMissions = <String>{};
  final Map<String, int> _missionScores = <String, int>{};
  final ContentUpdateService _contentService = ContentUpdateService();
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  String learnerName = 'Explorateur';
  int xp = 120;
  int streak = 3;
  String selectedDomain = 'Cartographie & SIG';

  double altitude = 90;
  double areaHectares = 24;
  double frontOverlap = 80;
  double sideOverlap = 70;
  double speed = 7;
  double shutter = 800;
  double brightness = 0;
  double cameraAngle = 0;

  List<RemoteCourse> remoteCourses = const <RemoteCourse>[];
  ContentManifest? availableManifest;
  UpdateState updateState = UpdateState.idle;
  String? updateError;
  DateTime? lastContentCheck;
  int installedContentVersion = 0;
  bool notificationsEnabled = true;
  String reminderFrequency = 'weekly';
  bool contentInitialized = false;

  Set<String> get completedLessons => Set.unmodifiable(_completedLessons);
  Set<String> get completedMissions => Set.unmodifiable(_completedMissions);
  Map<String, int> get missionScores => Map.unmodifiable(_missionScores);
  bool get updateAvailable =>
      availableManifest != null &&
      availableManifest!.contentVersion > installedContentVersion;

  bool lessonCompleted(String id) => _completedLessons.contains(id);
  bool missionCompleted(String id) => _completedMissions.contains(id);

  Future<void> initialize() async {
    var shouldCheckOnline = true;
    try {
      remoteCourses = await _contentService.loadInstalledCourses();
      installedContentVersion = await _contentService.getInstalledVersion();
      availableManifest = await _contentService.loadLastManifest();
      lastContentCheck = await _contentService.getLastCheckedAt();
      notificationsEnabled =
          await _prefs.getBool(_notificationsEnabledKey) ?? true;
      reminderFrequency =
          await _prefs.getString(_reminderFrequencyKey) ?? 'weekly';

      // Android 13+ affiche ici la demande système une seule fois. Sur le Web,
      // les notifications mobiles restent simplement désactivées.
      if (notificationsEnabled && !kIsWeb) {
        final granted = await NotificationService.instance.requestPermission();
        if (!granted) {
          notificationsEnabled = false;
          await _prefs.setBool(_notificationsEnabledKey, false);
          await BackgroundUpdateService.refreshSchedule(enabled: false);
        }
      }

      updateState = updateAvailable ? UpdateState.available : UpdateState.idle;
    } catch (error) {
      // L’application doit démarrer même si le stockage local ou un plugin
      // n’est pas disponible (notamment pendant les tests Flutter).
      updateError = error.toString();
      notificationsEnabled = false;
      shouldCheckOnline = false;
      updateState = UpdateState.idle;
    } finally {
      contentInitialized = true;
      notifyListeners();
    }

    if (shouldCheckOnline) {
      unawaited(checkForContentUpdates(silent: true));
    }
  }

  void completeLesson(String id) {
    if (_completedLessons.add(id)) {
      xp += 50;
      notifyListeners();
    }
  }

  void completeMission(String id, int score) {
    final firstCompletion = _completedMissions.add(id);
    final previous = _missionScores[id] ?? 0;
    if (score > previous) _missionScores[id] = score;
    if (firstCompletion) xp += 120;
    notifyListeners();
  }

  void setDomain(String value) {
    selectedDomain = value;
    notifyListeners();
  }

  void updatePlanner({
    double? newAltitude,
    double? newArea,
    double? newFrontOverlap,
    double? newSideOverlap,
    double? newSpeed,
  }) {
    altitude = newAltitude ?? altitude;
    areaHectares = newArea ?? areaHectares;
    frontOverlap = newFrontOverlap ?? frontOverlap;
    sideOverlap = newSideOverlap ?? sideOverlap;
    speed = newSpeed ?? speed;
    notifyListeners();
  }

  void updateCamera({
    double? newShutter,
    double? newBrightness,
    double? newCameraAngle,
  }) {
    shutter = newShutter ?? shutter;
    brightness = newBrightness ?? brightness;
    cameraAngle = newCameraAngle ?? cameraAngle;
    notifyListeners();
  }

  void rename(String value) {
    if (value.trim().isNotEmpty) {
      learnerName = value.trim();
      notifyListeners();
    }
  }

  double courseProgress(int totalLessons) {
    if (totalLessons == 0) return 0;
    return (_completedLessons.length / totalLessons).clamp(0.0, 1.0).toDouble();
  }

  Future<void> checkForContentUpdates({bool silent = false}) async {
    if (updateState == UpdateState.checking ||
        updateState == UpdateState.downloading) {
      return;
    }
    updateState = UpdateState.checking;
    updateError = null;
    if (!silent) notifyListeners();

    try {
      final result = await _contentService.checkForUpdates();
      availableManifest = result.manifest;
      installedContentVersion = result.installedVersion;
      lastContentCheck = DateTime.now();
      updateState = result.updateAvailable
          ? UpdateState.available
          : UpdateState.current;

      if (result.updateAvailable && notificationsEnabled) {
        final lastNotified = await _contentService.getLastNotifiedVersion();
        if (result.manifest.contentVersion > lastNotified) {
          await NotificationService.instance
              .showUpdateAvailable(result.manifest);
          await _contentService
              .markVersionNotified(result.manifest.contentVersion);
        }
      }
    } catch (error) {
      updateError = error.toString();
      updateState = updateAvailable ? UpdateState.available : UpdateState.error;
    }
    notifyListeners();
  }

  Future<bool> installAvailableContent() async {
    final manifest = availableManifest;
    if (manifest == null || !updateAvailable) return false;

    updateState = UpdateState.downloading;
    updateError = null;
    notifyListeners();
    try {
      remoteCourses = await _contentService.install(manifest);
      installedContentVersion = manifest.contentVersion;
      updateState = UpdateState.current;
      xp += 30;
      if (notificationsEnabled) {
        await NotificationService.instance
            .showCoursesInstalled(remoteCourses.length);
      }
      notifyListeners();
      return true;
    } catch (error) {
      updateError = error.toString();
      updateState = UpdateState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> clearDownloadedContent() async {
    await _contentService.clearDownloadedContent();
    remoteCourses = const <RemoteCourse>[];
    installedContentVersion = 0;
    updateState = availableManifest == null
        ? UpdateState.idle
        : UpdateState.available;
    notifyListeners();
  }

  Future<bool> setNotificationsEnabled(bool enabled) async {
    if (enabled) {
      final granted = await NotificationService.instance.requestPermission();
      if (!granted) {
        notificationsEnabled = false;
        await _prefs.setBool(_notificationsEnabledKey, false);
        await BackgroundUpdateService.refreshSchedule(enabled: false);
        notifyListeners();
        return false;
      }
    }
    notificationsEnabled = enabled;
    await _prefs.setBool(_notificationsEnabledKey, enabled);
    await BackgroundUpdateService.refreshSchedule(enabled: enabled);
    notifyListeners();
    return true;
  }

  Future<void> setReminderFrequency(String frequency) async {
    reminderFrequency = frequency;
    await _prefs.setString(_reminderFrequencyKey, frequency);
    notifyListeners();
  }

  Future<void> sendTestNotification() async {
    await NotificationService.instance.showLearningReminder();
  }

  @override
  void dispose() {
    _contentService.dispose();
    super.dispose();
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope introuvable dans le contexte');
    return scope!.notifier!;
  }
}
