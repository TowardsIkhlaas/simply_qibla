// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appNamePascalCase => 'SimplyQibla';

  @override
  String get appAboutLegalese => '© 2024 TowardsIkhlaas';

  @override
  String get changeLocationBarText => 'Zu einem bestimmten Ort springen? :)';

  @override
  String get latitudeFieldLabel => 'Breitengrad';

  @override
  String get longitudeFieldLabel => 'Längengrad';

  @override
  String get skipText => 'Überspringen';

  @override
  String get doneText => 'Fertig';

  @override
  String get okText => 'OK';

  @override
  String get cancelText => 'Abbrechen';

  @override
  String get clearText => 'Löschen';

  @override
  String get allowText => 'ZULASSEN';

  @override
  String get turnOnText => 'AKTIVIEREN';

  @override
  String get coordinatesInputFormTitle => 'Koordinaten eingeben';

  @override
  String get centerConsoleCenteringText => 'Standort wird ermittelt...';

  @override
  String get centerConsoleDraggingText =>
      'Anheben, um die Qibla-Linie anzuzeigen';

  @override
  String get centerConsoleIdleText => 'km bis zur Kaaba';

  @override
  String get locationDisabled => 'Ihr Standort ist deaktiviert.';

  @override
  String get locationDeniedInitial =>
      'Bitte erlauben Sie die Standortberechtigung, um diese Funktion zu nutzen. Wir speichern oder verkaufen Ihre Daten nicht. :)';

  @override
  String get locationDeniedPermanent =>
      'Bitte erlauben Sie die Standortberechtigung, um diese Funktion zu nutzen.';

  @override
  String get latitudeErrorText => 'Ungültiger Breitengrad-Wert';

  @override
  String get longitudeErrorText => 'Ungültiger Längengrad-Wert';

  @override
  String get thankYouText => 'JazakAllahu Khayran für die Nutzung dieser App!';

  @override
  String get supportAppealText =>
      'Diese App verursacht Kosten für Betrieb und Wartung (Google Maps API). Bitte unterstützen Sie das Projekt über die untenstehenden Buttons (überschüssige Beträge werden an registrierte Wohltätigkeitsorganisationen gespendet).';

  @override
  String get githubButtonText => 'Support auf GitHub';

  @override
  String get donateButtonText => 'Support auf Ko-Fi';

  @override
  String get socialInstagramButtonText => 'Folgen Sie uns auf Instagram';

  @override
  String get shareButtonText => 'Mit Freunden teilen';

  @override
  String get shareContentText =>
      'As-salamu alaykum wa rahmatullahi wa barakatuh! Schau dir diese schöne und genaue Qibla-App an';

  @override
  String get onboardingUsageTitle => 'Wie funktioniert das?';

  @override
  String get onboardingLocationTitle =>
      'Lassen Sie die App Ihren Standort finden.';

  @override
  String get onboardingSupportTitle => 'Unterstützen Sie unsere Mission!';

  @override
  String get onboardingUsageBody =>
      'Salaam! Um die App zu nutzen, halten Sie Ihr Gerät flach und drehen Sie es, um sich an nahegelegenen Orientierungspunkten auf der Karte auszurichten, wie Straßen und Gebäuden in Ihrer Umgebung.';

  @override
  String get onboardingLocationBody =>
      'Standortberechtigungen sind notwendig, damit die App optimal funktioniert, aber nicht zwingend erforderlich. Seien Sie versichert, Ihre Daten werden weder gesammelt noch verkauft.';

  @override
  String get onboardingSupportBody =>
      'SimplyQibla ist werbefrei und Open-Source. Wenn Ihnen gefällt, was Sie sehen, unterstützen Sie uns bitte über die In-App-Links. Ihre Unterstützung wird verwendet, um die App zu betreiben, und Überschüsse werden an registrierte Wohltätigkeitsorganisationen gespendet.';
}
