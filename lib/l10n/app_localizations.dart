import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('id'),
    Locale('ms'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT')
  ];

  /// Name of the app in PascalCase where supported.
  ///
  /// In en, this message translates to:
  /// **'SimplyQibla'**
  String get appNamePascalCase;

  /// Legal text appearing in the About section of the app.
  ///
  /// In en, this message translates to:
  /// **'© 2024 TowardsIkhlaas'**
  String get appAboutLegalese;

  /// Prompt asking the user if they want to navigate to a specific location.
  ///
  /// In en, this message translates to:
  /// **'Jump to a specific location? :)'**
  String get changeLocationBarText;

  /// Label for latitude input field.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitudeFieldLabel;

  /// Label for longitude input field.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitudeFieldLabel;

  /// Text used as a button label, typically for skipping through something.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipText;

  /// Text used as a button label, typically for finishing an action.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneText;

  /// Text used as a button label, typically for confirming an action.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okText;

  /// Text used as a button label, typically for canceling an action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelText;

  /// Text used as a button label, typically for clearing a field.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearText;

  /// Text used as a button label, typically within a snackbar for allowing a permission.
  ///
  /// In en, this message translates to:
  /// **'ALLOW'**
  String get allowText;

  /// Text used as a button label, typically within a snackbar for turning on a service.
  ///
  /// In en, this message translates to:
  /// **'TURN ON'**
  String get turnOnText;

  /// Text shown as the title of coordinates input form.
  ///
  /// In en, this message translates to:
  /// **'Enter Coordinates'**
  String get coordinatesInputFormTitle;

  /// Message displayed while the app is determining the user's current location.
  ///
  /// In en, this message translates to:
  /// **'Locating you...'**
  String get centerConsoleCenteringText;

  /// Text indicating that the user should lift their finger to reveal the Qibla direction line.
  ///
  /// In en, this message translates to:
  /// **'Lift to show Qibla line'**
  String get centerConsoleDraggingText;

  /// Text displayed in idle state, showing the distance from the user's location to the Kaaba.
  ///
  /// In en, this message translates to:
  /// **'km to the Kaaba'**
  String get centerConsoleIdleText;

  /// Warning message indicating that the user's location services are disabled.
  ///
  /// In en, this message translates to:
  /// **'Your location is off.'**
  String get locationDisabled;

  /// Message asking the user to allow location permission, with a privacy reassurance statement.
  ///
  /// In en, this message translates to:
  /// **'Please allow location permission to use this feature. We do not store or sell your data. :)'**
  String get locationDeniedInitial;

  /// Message requesting the user to allow location permission after they have previously denied it permanently.
  ///
  /// In en, this message translates to:
  /// **'Please allow location permission to use this feature.'**
  String get locationDeniedPermanent;

  /// Error message shown when inputting an invalid latitude.
  ///
  /// In en, this message translates to:
  /// **'Invalid latitude value'**
  String get latitudeErrorText;

  /// Error message shown when inputting an invalid longitude.
  ///
  /// In en, this message translates to:
  /// **'Invalid longitude value'**
  String get longitudeErrorText;

  /// Gratitude message shown to users, thanking them for using the app.
  ///
  /// In en, this message translates to:
  /// **'JazakAllahu Khayran for using this app!'**
  String get thankYouText;

  /// Appeal asking users to support the app through donations, mentioning that excess funds will be donated to charity.
  ///
  /// In en, this message translates to:
  /// **'This app costs to run and maintain (Google Maps API). Please consider supporting the project through the buttons below (excess amounts will be donated to registered charities).'**
  String get supportAppealText;

  /// Button text that directs users to GitHub to support the project.
  ///
  /// In en, this message translates to:
  /// **'Support us on GitHub'**
  String get githubButtonText;

  /// Button text that directs users to Ko-Fi to support the project.
  ///
  /// In en, this message translates to:
  /// **'Support us on Ko-Fi'**
  String get donateButtonText;

  /// Button text encouraging users to follow the project on Instagram.
  ///
  /// In en, this message translates to:
  /// **'Follow us on Instagram'**
  String get socialInstagramButtonText;

  /// Button text allowing users to share the app with friends.
  ///
  /// In en, this message translates to:
  /// **'Share with Friends'**
  String get shareButtonText;

  /// Text content used when users share the app with others.
  ///
  /// In en, this message translates to:
  /// **'As salaam alaykum warahmatullahi wabarakatuh! Check out this beautiful and accurate Qibla app'**
  String get shareContentText;

  /// Title for the onboarding section explaining how to use the app.
  ///
  /// In en, this message translates to:
  /// **'How does this work?'**
  String get onboardingUsageTitle;

  /// Title for the onboarding section that explains the need for location permissions.
  ///
  /// In en, this message translates to:
  /// **'Let the app find you.'**
  String get onboardingLocationTitle;

  /// Title for the onboarding section that encourages users to support the project.
  ///
  /// In en, this message translates to:
  /// **'Support our mission!'**
  String get onboardingSupportTitle;

  /// Body text explaining to the user how to operate the app by aligning with landmarks on the map.
  ///
  /// In en, this message translates to:
  /// **'Salaam! To use the app, hold your device flat and rotate it to align with nearby landmarks shown in the map, like streets and buildings around you.'**
  String get onboardingUsageBody;

  /// Body text explaining why location permissions are requested and reassuring users about data privacy.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are needed for the app to function ideally, but not required. Rest assured, your data is neither collected nor sold.'**
  String get onboardingLocationBody;

  /// Body text encouraging users to support the project and explaining how donations will be used.
  ///
  /// In en, this message translates to:
  /// **'SimplyQibla is ad-free and open-source. If you like what you see, please support us through the in-app links. Your support will be used to run the app, and excess will be donated to registered charities.'**
  String get onboardingSupportBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'fr',
        'id',
        'ms',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'ms':
      return AppLocalizationsMs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
