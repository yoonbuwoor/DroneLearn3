import 'package:flutter/material.dart';

const navy = Color(0xFF06131F);
const deepNavy = Color(0xFF091C2B);
const panel = Color(0xFF102638);
const cyan = Color(0xFF00D1C7);
const orange = Color(0xFFFF9E4A);
const violet = Color(0xFF8B7CFF);
const success = Color(0xFF5DD39E);
const danger = Color(0xFFFF6B7A);

ThemeData buildDroneTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: cyan,
    brightness: brightness,
    surface: dark ? panel : const Color(0xFFF7FAFC),
  ).copyWith(
    primary: cyan,
    secondary: orange,
    tertiary: violet,
    error: danger,
  );

  final textTheme = Typography.material2021(platform: TargetPlatform.android)
      .white
      .apply(
        bodyColor: dark ? const Color(0xFFEAF4F7) : const Color(0xFF10212C),
        displayColor: dark ? Colors.white : navy,
      );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? navy : const Color(0xFFF3F7F9),
    textTheme: textTheme,
    appBarTheme: AppBarThemeData(
      backgroundColor: Colors.transparent,
      foregroundColor: dark ? Colors.white : navy,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: dark ? Colors.white : navy,
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
    ),
    cardTheme: CardThemeData(
      color: dark ? panel : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: dark ? Colors.white.withOpacity(.06) : const Color(0xFFE4ECEF),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: dark ? Colors.white.withOpacity(.08) : const Color(0xFFE3EBEE),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: dark ? const Color(0xFF081A28) : Colors.white,
      indicatorColor: cyan.withOpacity(dark ? .20 : .15),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          color: states.contains(WidgetState.selected)
              ? (dark ? Colors.white : navy)
              : scheme.onSurfaceVariant,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w900
              : FontWeight.w600,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: dark ? const Color(0xFF081A28) : Colors.white,
      indicatorColor: cyan.withOpacity(dark ? .20 : .15),
      selectedIconTheme: const IconThemeData(color: cyan),
      selectedLabelTextStyle: TextStyle(
        color: dark ? Colors.white : navy,
        fontWeight: FontWeight.w900,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? Colors.white.withOpacity(.055) : Colors.white,
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: dark ? Colors.white.withOpacity(.08) : const Color(0xFFDCE7EA),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: cyan, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: cyan,
        foregroundColor: navy,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w900),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: dark ? Colors.white24 : Colors.black12),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: dark ? Colors.white12 : Colors.black12),
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: cyan,
      thumbColor: cyan,
      inactiveTrackColor: cyan.withOpacity(.16),
      overlayColor: cyan.withOpacity(.12),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: cyan),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: dark ? const Color(0xFF173247) : navy,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
