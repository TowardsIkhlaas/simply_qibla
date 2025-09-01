// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appNamePascalCase => 'SimplyQibla';

  @override
  String get appAboutLegalese => '© 2024 TowardsIkhlaas';

  @override
  String get changeLocationBarText => 'Jump to a specific location? :)';

  @override
  String get latitudeFieldLabel => 'Latitude';

  @override
  String get longitudeFieldLabel => 'Longitude';

  @override
  String get skipText => 'Skip';

  @override
  String get doneText => 'Done';

  @override
  String get okText => 'OK';

  @override
  String get cancelText => 'Cancel';

  @override
  String get clearText => 'Clear';

  @override
  String get allowText => 'ALLOW';

  @override
  String get turnOnText => 'TURN ON';

  @override
  String get coordinatesInputFormTitle => 'Enter Coordinates';

  @override
  String get centerConsoleCenteringText => 'Locating you...';

  @override
  String get centerConsoleDraggingText => 'Lift to show Qibla line';

  @override
  String get centerConsoleIdleText => 'km to the Kaaba';

  @override
  String get locationDisabled => 'Your location is off.';

  @override
  String get locationDeniedInitial =>
      'Please allow location permission to use this feature. We do not store or sell your data. :)';

  @override
  String get locationDeniedPermanent =>
      'Please allow location permission to use this feature.';

  @override
  String get latitudeErrorText => 'Invalid latitude value';

  @override
  String get longitudeErrorText => 'Invalid longitude value';

  @override
  String get thankYouText => 'JazakAllahu Khayran for using this app!';

  @override
  String get supportAppealText =>
      'This app costs to run and maintain (Google Maps API). Please consider supporting the project through the buttons below (excess amounts will be donated to registered charities).';

  @override
  String get githubButtonText => 'Support us on GitHub';

  @override
  String get donateButtonText => 'Support us on Ko-Fi';

  @override
  String get socialInstagramButtonText => 'Follow us on Instagram';

  @override
  String get shareButtonText => 'Share with Friends';

  @override
  String get shareContentText =>
      'As salaam alaykum warahmatullahi wabarakatuh! Check out this beautiful and accurate Qibla app';

  @override
  String get onboardingUsageTitle => 'How does this work?';

  @override
  String get onboardingLocationTitle => 'Let the app find you.';

  @override
  String get onboardingSupportTitle => 'Support our mission!';

  @override
  String get onboardingUsageBody =>
      'Salaam! To use the app, hold your device flat and rotate it to align with nearby landmarks shown in the map, like streets and buildings around you.';

  @override
  String get onboardingLocationBody =>
      'Location permissions are needed for the app to function ideally, but not required. Rest assured, your data is neither collected nor sold.';

  @override
  String get onboardingSupportBody =>
      'SimplyQibla is ad-free and open-source. If you like what you see, please support us through the in-app links. Your support will be used to run the app, and excess will be donated to registered charities.';
}
