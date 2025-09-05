// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appNamePascalCase => 'SimplyQibla';

  @override
  String get appAboutLegalese => '© 2024 TowardsIkhlaas';

  @override
  String get changeLocationBarText => 'Aller à un lieu spécifique ? :)';

  @override
  String get latitudeFieldLabel => 'Latitude';

  @override
  String get longitudeFieldLabel => 'Longitude';

  @override
  String get skipText => 'Ignorer';

  @override
  String get doneText => 'Terminé';

  @override
  String get okText => 'OK';

  @override
  String get cancelText => 'Annuler';

  @override
  String get clearText => 'Effacer';

  @override
  String get allowText => 'AUTORISER';

  @override
  String get turnOnText => 'ACTIVER';

  @override
  String get coordinatesInputFormTitle => 'Entrer les coordonnées';

  @override
  String get centerConsoleCenteringText => 'Localisation en cours...';

  @override
  String get centerConsoleDraggingText =>
      'Soulevez pour afficher la ligne de Qibla';

  @override
  String get centerConsoleIdleText => 'km jusqu\'à la Kaaba';

  @override
  String get locationDisabled => 'Votre localisation est désactivée.';

  @override
  String get locationDeniedInitial =>
      'Veuillez autoriser la permission de localisation pour utiliser cette fonctionnalité. Nous ne stockons ni ne vendons vos données. :)';

  @override
  String get locationDeniedPermanent =>
      'Veuillez autoriser la permission de localisation pour utiliser cette fonctionnalité.';

  @override
  String get latitudeErrorText => 'Valeur de latitude invalide';

  @override
  String get longitudeErrorText => 'Valeur de longitude invalide';

  @override
  String get thankYouText =>
      'JazakAllahu Khayran d\'utiliser cette application !';

  @override
  String get supportAppealText =>
      'Cette application a des coûts de fonctionnement et de maintenance (API Google Maps). Veuillez envisager de soutenir le projet via les boutons ci-dessous (les montants excédentaires seront donnés à des associations caritatives enregistrées).';

  @override
  String get githubButtonText => 'Soutenez-nous sur GitHub';

  @override
  String get donateButtonText => 'Soutenez-nous sur Ko-Fi';

  @override
  String get socialInstagramButtonText => 'Suivez-nous sur Instagram';

  @override
  String get shareButtonText => 'Partager avec des amis';

  @override
  String get shareContentText =>
      'As salam alaykum warahmatullahi wabarakatuh ! Découvrez cette belle application de Qibla, précise et pratique.';

  @override
  String get onboardingUsageTitle => 'Comment ça marche ?';

  @override
  String get onboardingLocationTitle =>
      'Laissez l\'application vous localiser.';

  @override
  String get onboardingSupportTitle => 'Soutenez notre mission !';

  @override
  String get onboardingUsageBody =>
      'Salaam ! Pour utiliser l\'application, tenez votre appareil à plat et faites-le pivoter pour l\'aligner avec les points de repère proches affichés sur la carte, tels que les rues et les bâtiments autour de vous.';

  @override
  String get onboardingLocationBody =>
      'Les autorisations de localisation sont nécessaires pour que l\'application fonctionne de manière optimale, mais ne sont pas obligatoires. Soyez rassurés, vos données ne sont ni collectées ni vendues.';

  @override
  String get onboardingSupportBody =>
      'SimplyQibla est sans publicité et open-source. Si vous aimez ce que vous voyez, veuillez nous soutenir via les liens dans l\'application. Votre soutien servira à faire fonctionner l\'application, et les excédents seront donnés à des œuvres caritatives enregistrées.';
}
