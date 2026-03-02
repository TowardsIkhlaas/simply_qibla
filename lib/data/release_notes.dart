import 'package:simply_qibla/l10n/app_localizations.dart';

/// Data structure representing release notes for a version.
class ReleaseNotes {
  const ReleaseNotes({
    required this.version,
    this.features = const <String>[],
    this.improvements = const <String>[],
    this.fixes = const <String>[],
  });

  final String version;

  /// Localization keys for new features
  final List<String> features;

  /// Localization keys for improvements
  final List<String> improvements;

  /// Localization keys for bug fixes
  final List<String> fixes;

  bool get hasFeatures => features.isNotEmpty;
  bool get hasImprovements => improvements.isNotEmpty;
  bool get hasFixes => fixes.isNotEmpty;

  /// Resolves a localization key to its translated string
  String resolveKey(String key, AppLocalizations l10n) {
    switch (key) {
      case 'whatsNewFeatureCompassRotation':
        return l10n.whatsNewFeatureCompassRotation;
      case 'whatsNewFeatureColorThemes':
        return l10n.whatsNewFeatureColorThemes;
      case 'whatsNewFeatureLightDarkMode':
        return l10n.whatsNewFeatureLightDarkMode;
      case 'whatsNewImprovementPolyline':
        return l10n.whatsNewImprovementPolyline;
      case 'whatsNewImprovementCompassToggle':
        return l10n.whatsNewImprovementCompassToggle;
      case 'whatsNewImprovementGeneral':
        return l10n.whatsNewImprovementGeneral;
      case 'whatsNewFixOnboardingContrast':
        return l10n.whatsNewFixOnboardingContrast;
      case 'whatsNewFixFirstOpenSetup':
        return l10n.whatsNewFixFirstOpenSetup;
      default:
        return key;
    }
  }
}

/// Current release notes to display in the What's New modal.
const ReleaseNotes currentRelease = ReleaseNotes(
  version: '3.3.0',
  features: <String>[],
  improvements: <String>[],
  fixes: <String>[
    'whatsNewFixFirstOpenSetup',
  ],
);
