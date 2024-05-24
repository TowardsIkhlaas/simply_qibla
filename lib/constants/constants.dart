class MapConstants {
  static const double defaultLatitude = 21.41940349340265;
  static const double defaultLongitude = 39.82562665088553;
  static const double qiblaLatitude = 21.42253495661983;
  static const double qiblaLongitude = 39.82618860061329;
  static const double zoomLevel = 19.0;
  static const int polylineWidth = 10;
}

class AppStrings {
  static const String appNamePascalCase = 'SimplyQibla';
  static const String appAboutLegalese = '© 2024 TowardsIkhlaas';
  static const String thankYouText = 'JazakAllahu Khayran for using this app!';
  static const String changeLocationBarText = 'Jump to a specific location? :)';
  static const String supportAppealText = 'This app costs to run and maintain (Google Maps API). Please consider supporting the project through the below buttons.';
  static const String githubButtonText = 'Support us on GitHub';
  static const String donateButtonText = 'Support us on Ko-Fi';
  static const String shareButtonText = 'Share with Friends';
  static const String githubUriPath = 'https://github.com/sponsors/TowardsIkhlaas';
  static const String donateUriPath = 'https://ko-fi.com/TowardsIkhlaas';
  static const String shareContentText = 'Check out this convenient Qibla app';
  static const String androidAppLink = 'playstore/SimplyQibla';
  static const String iosAppLink = 'appstore/SimplyQibla';
}

class InputValidation {
  static RegExp latitudeValidatorPattern = RegExp(
    r'^(\+|-)?(?:90(?:(?:\.0{1,15})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,15})?))$'
  );
  static RegExp longitudeValidatorPattern = RegExp(
    r'^(\+|-)?(?:180(?:(?:\.0{1,15})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,15})?))$'
  );
}
