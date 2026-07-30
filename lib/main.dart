import 'package:flutter/material.dart';

import 'app.dart';
import 'services/background_update_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationService.instance.initialize();
    await BackgroundUpdateService.initialize();
  } catch (_) {
    // Les fonctions pédagogiques restent accessibles si Android refuse
    // momentanément un service système au démarrage.
  }
  runApp(const DroneAtlasApp());
}
