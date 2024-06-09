import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/globals/globals.dart';
import 'package:simply_qibla/helpers/maps_renderer_helper.dart';
import 'package:simply_qibla/helpers/shared_preferences_helper.dart';
import 'package:simply_qibla/pages/map_page.dart';
import 'package:simply_qibla/pages/onboarding_page.dart';
import 'package:simply_qibla/theme/theme.dart';

bool hasSeenOnboarding = false;

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appNamePascalCase,
      themeMode: ThemeMode.dark,
      darkTheme: AppThemes.darkTheme,
      home: hasSeenOnboarding ? const MapPage() : const OnboardingPage(),
      scaffoldMessengerKey: snackbarKey,
    );
  }
}
