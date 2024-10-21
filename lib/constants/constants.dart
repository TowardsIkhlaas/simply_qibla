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
  // Links

  static const String githubUriPath =
      'https://github.com/TowardsIkhlaas/simply_qibla/blob/master/.github/CONTRIBUTING.md';
  static const String donateUriPath = 'https://ko-fi.com/TowardsIkhlaas';
  static const String socialInstagramUriPath = 'https://www.instagram.com/towardsikhlaas';
  static const String shareContentText =
      'As salaam alaykum warahmatullahi wabarakatuh! Check out this beautiful and accurate Qibla app';
  static const String landingPageLink = 'https://simplyqibla.towardsikhlaas.com';
  static const String androidAppLink =
      'https://play.google.com/store/apps/details?id=com.towardsikhlaas.simplyqibla';
  static const String iosAppLink = 'https://apps.apple.com/app/id6504881956';
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
