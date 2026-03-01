import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:simply_qibla/globals/globals.dart';
import 'package:simply_qibla/helpers/maps_renderer_helper.dart';
import 'package:simply_qibla/helpers/shared_preferences_helper.dart';
import 'package:simply_qibla/l10n/app_localizations.dart';
import 'package:simply_qibla/pages/map_page.dart';
import 'package:simply_qibla/pages/onboarding_page.dart';
import 'package:simply_qibla/theme/theme.dart';

bool hasSeenOnboarding = false;
String initialThemeMode = 'system';
String initialColorMode = 'default';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  if (Platform.isAndroid) {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
      initializeMapRenderer();
    }
  }

  hasSeenOnboarding = await getOnboardingStatus();
  initialThemeMode = await getThemeMode();
  initialColorMode = await getColorMode();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String _themeMode;
  late String _colorMode;

  @override
  void initState() {
    super.initState();
    _themeMode = initialThemeMode;
    _colorMode = initialColorMode;
  }

  ThemeMode _getThemeMode() {
    switch (_themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void _onThemeChanged(String mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _onColorChanged(String mode) {
    setState(() {
      _colorMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTheme colorTheme = AppColorTheme.fromKey(_colorMode);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Only pass dynamic colors when on Android and dynamic theme is selected
        final bool useDynamicColor =
            Platform.isAndroid && colorTheme == AppColorTheme.dynamic;
        final ColorScheme? effectiveLightDynamic =
            useDynamicColor ? lightDynamic : null;
        final ColorScheme? effectiveDarkDynamic =
            useDynamicColor ? darkDynamic : null;

        return MaterialApp(
          onGenerateTitle: (BuildContext context) {
            return AppLocalizations.of(context)!.appNamePascalCase;
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: _getThemeMode(),
          theme: AppThemes.buildLightTheme(
            effectiveLightDynamic,
            colorTheme: colorTheme,
          ),
          darkTheme: AppThemes.buildDarkTheme(
            effectiveDarkDynamic,
            colorTheme: colorTheme,
          ),
          home: hasSeenOnboarding
              ? MapPage(
                  onThemeChanged: _onThemeChanged,
                  onColorChanged: _onColorChanged,
                )
              : const OnboardingPage(),
          scaffoldMessengerKey: snackbarKey,
        );
      },
    );
  }
}
