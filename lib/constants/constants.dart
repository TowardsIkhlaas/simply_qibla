import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapConstants {
  static const double zoomLevel = 19.0;
  static const int polylineWidth = 10;
  static const LatLng defaultPosition = LatLng(
    21.41940349340265,
    39.82562665088553,
  );
  static const LatLng qiblaPosition = LatLng(
    21.42253495661983,
    39.82618860061329,
  );
}

enum CenterConsoleState {
  centering,
  dragging,
  idle,
}

class AppStrings {
  // Meta

  static const String appNamePascalCase = 'SimplyQibla';
  static const String appAboutLegalese = '© 2024 TowardsIkhlaas';

  // App Text

  static const String changeLocationBarText = 'Jump to a specific location? :)';
  static const String centerConsoleCenteringText = 'Locating you...';
  static const String centerConsoleDraggingText =
      'Lift finger to show Qibla line';
  static const String centerConsoleIdleText = 'km to the Kaaba';

  // Errors and Warnings

  static const String locationDisabled = 'Your location is off.';
  static const String locationDeniedInitial =
      'Please allow the app to use your location. Your data is not collected or sold.';
  static const String locationDeniedPermanent =
      'Please allow location permission for the app to use this function.';

  // User Experience

  static const String thankYouText = 'JazakAllahu Khayran for using this app!';
  static const String supportAppealText =
      'This app costs to run and maintain (Google Maps API). Please consider supporting the project through the below buttons.';
  static const String githubButtonText = 'Support us on GitHub';
  static const String donateButtonText = 'Support us on Ko-Fi';
  static const String shareButtonText = 'Share with Friends';
  static const String onboardingUsageTitle = 'How does this work?';
  static const String onboardingLocationTitle = 'Let the app find you.';
  static const String onboardingSupportTitle = 'Support our mission!';
  static const String onboardingUsageBody =
      'Thanks for downloading SimplyQibla! To use the app, orient yourself to the qibla direction by observing surrounding landmarks (like roads and buildings).';
  static const String onboardingLocationBody =
      'Location permissions are needed for the app to function ideally. Rest assured, your data is neither collected nor sold.';
  static const String onboardingSupportBody =
      'SimplyQibla is ad-free and open-source. If you like what you see, please support us through the in-app links. Your support will be used to run the app, and excess will be donated to registered charities.';

  // Links

  static const String githubUriPath =
      'https://github.com/sponsors/TowardsIkhlaas';
  static const String donateUriPath = 'https://ko-fi.com/TowardsIkhlaas';
  static const String shareContentText = 'Check out this convenient Qibla app';
  static const String androidAppLink = 'playstore/SimplyQibla';
  static const String iosAppLink = 'appstore/SimplyQibla';
}

class AppStatusCodes {
  static const int locationDisabled = 701;
  static const int locationDeniedInitial = 702;
  static const int locationDeniedPermanent = 704;
}

class InputValidation {
  static RegExp latitudeValidatorPattern = RegExp(
      r'^(\+|-)?(?:90(?:(?:\.0{1,15})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,15})?))$');
  static RegExp longitudeValidatorPattern = RegExp(
      r'^(\+|-)?(?:180(?:(?:\.0{1,15})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,15})?))$');
}
