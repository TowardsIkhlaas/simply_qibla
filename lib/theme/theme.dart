import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Color overrides for light and dark modes
class ThemeColorOverrides {
  const ThemeColorOverrides({
    this.primary,
    this.onPrimary,
    this.surface,
    this.onSurface,
    this.onSurfaceVariant,
    this.outline,
  });

  final Color? primary;
  final Color? onPrimary;
  final Color? surface;
  final Color? onSurface;
  final Color? onSurfaceVariant;
  final Color? outline;

  /// No overrides
  static const ThemeColorOverrides none = ThemeColorOverrides();
}

/// Predefined color themes for the app
enum AppColorTheme {
  /// Default amber/gold theme
  defaultTheme(
    key: 'default',
    seedColor: Color(0xFFFFD54F),
    lightScaffold: Color(0xFFFAF8F6),
    darkScaffold: Color(0xFF151213),
  ),

  /// Dynamic colors from device (Android only)
  dynamic(
    key: 'dynamic',
    seedColor: null,
    lightScaffold: Color(0xFFFAF8F6),
    darkScaffold: Color(0xFF151213),
  ),

  /// Green theme inspired by Madinah
  madinah(
    key: 'madinah',
    seedColor: Color(0xFF044e25),
    lightScaffold: Color(0xFFfff3de),
    darkScaffold: Color(0xFF1f1c17),
    // Override primary to a specific shade of green
    lightOverrides: ThemeColorOverrides(
      primary: Color(0xFF044e25),
      outline: Color(0xFF044e25),
    ),
    darkOverrides: ThemeColorOverrides(
      primary: Color(0xFFb3986d),
      outline: Color(0xFFb3986d),
    ),
  ),

  /// Green theme inspired by Al-Aqsa
  aqsa(
    key: 'aqsa',
    seedColor: Color(0xFF0535bc),
    lightScaffold: Color(0xFFfff3de),
    darkScaffold: Color(0xFF032a42),
    // Override primary to a specific shade of green
    lightOverrides: ThemeColorOverrides(
      primary: Color(0xFF0535bc),
      outline: Color(0xFF0535bc),
    ),
    darkOverrides: ThemeColorOverrides(
      primary: Color(0xFFf0d30f),
      outline: Color(0xFFf0d30f),
    ),
  );

  const AppColorTheme({
    required this.key,
    required this.seedColor,
    required this.lightScaffold,
    required this.darkScaffold,
    this.lightOverrides = ThemeColorOverrides.none,
    this.darkOverrides = ThemeColorOverrides.none,
  });

  final String key;
  final Color? seedColor;
  final Color lightScaffold;
  final Color darkScaffold;
  final ThemeColorOverrides lightOverrides;
  final ThemeColorOverrides darkOverrides;

  static AppColorTheme fromKey(String key) {
    return AppColorTheme.values.firstWhere(
      (AppColorTheme theme) => theme.key == key,
      orElse: () => AppColorTheme.defaultTheme,
    );
  }
}

class AppThemes {
  static const TextTheme _textTheme = TextTheme(
    titleLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w900,
      letterSpacing: -2,
    ),
    titleMedium: TextStyle(
      fontSize: 24.0,
      letterSpacing: -1,
    ),
    titleSmall: TextStyle(
      fontSize: 18.0,
      letterSpacing: -0.50,
    ),
    bodyLarge: TextStyle(
      letterSpacing: -0.50,
    ),
    bodyMedium: TextStyle(
      letterSpacing: -0.25,
    ),
    bodySmall: TextStyle(
      letterSpacing: -0.25,
    ),
    labelLarge: TextStyle(
      letterSpacing: -0.25,
    ),
    labelMedium: TextStyle(
      letterSpacing: -0.25,
    ),
    labelSmall: TextStyle(
      letterSpacing: -0.25,
    ),
  );

  static ColorScheme _applyOverrides(
    ColorScheme base,
    ThemeColorOverrides overrides,
  ) {
    return base.copyWith(
      primary: overrides.primary,
      onPrimary: overrides.onPrimary,
      surface: overrides.surface,
      onSurface: overrides.onSurface,
      onSurfaceVariant: overrides.onSurfaceVariant,
      outline: overrides.outline,
    );
  }

  static ThemeData buildDarkTheme(
    ColorScheme? dynamicColorScheme, {
    AppColorTheme colorTheme = AppColorTheme.defaultTheme,
  }) {
    ColorScheme colorScheme;
    Color scaffoldColor;

    if (colorTheme == AppColorTheme.dynamic && dynamicColorScheme != null) {
      colorScheme = dynamicColorScheme.harmonized();
      // Use the dynamic scheme's surface color for scaffold
      scaffoldColor = colorScheme.surfaceContainerLowest;
    } else {
      final Color seedColor =
          colorTheme.seedColor ?? AppColorTheme.defaultTheme.seedColor!;
      colorScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      );
      scaffoldColor = colorTheme.darkScaffold;
    }

    // Apply any color overrides
    colorScheme = _applyOverrides(colorScheme, colorTheme.darkOverrides);

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldColor,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -1,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      fontFamily: 'Inter',
      textTheme: _textTheme,
    );
  }

  static ThemeData buildLightTheme(
    ColorScheme? dynamicColorScheme, {
    AppColorTheme colorTheme = AppColorTheme.defaultTheme,
  }) {
    ColorScheme colorScheme;
    Color scaffoldColor;

    if (colorTheme == AppColorTheme.dynamic && dynamicColorScheme != null) {
      colorScheme = dynamicColorScheme.harmonized();
      // Use the dynamic scheme's surface color for scaffold
      scaffoldColor = colorScheme.surfaceContainerLow;
    } else {
      final Color seedColor =
          colorTheme.seedColor ?? AppColorTheme.defaultTheme.seedColor!;
      colorScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      );
      scaffoldColor = colorTheme.lightScaffold;
    }

    // Apply any color overrides
    colorScheme = _applyOverrides(colorScheme, colorTheme.lightOverrides);

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldColor,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          letterSpacing: -1,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
      ),
      fontFamily: 'Inter',
      textTheme: _textTheme,
    );
  }

  // Legacy darkTheme getter for backwards compatibility
  static ThemeData get darkTheme => buildDarkTheme(null);

  static const Color githubPrimaryColor = Colors.white;
  static const Color githubSecondaryColor = Color.fromRGBO(14, 17, 23, 1.0);
  static const Color socialInstagramPrimaryColor = Colors.pink;
  static const Color socialInstagramSecondaryColor = Colors.white;
}
