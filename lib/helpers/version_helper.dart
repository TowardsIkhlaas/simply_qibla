/// Compares two version strings (e.g., "3.0.4" vs "3.0.3").
/// Returns:
/// - -1 if v1 < v2
/// - 0 if v1 == v2
/// - 1 if v1 > v2
int compareVersions(String v1, String v2) {
  final List<int> parts1 = v1.split('.').map(int.parse).toList();
  final List<int> parts2 = v2.split('.').map(int.parse).toList();

  // Pad shorter version with zeros
  while (parts1.length < parts2.length) {
    parts1.add(0);
  }
  while (parts2.length < parts1.length) {
    parts2.add(0);
  }

  for (int i = 0; i < parts1.length; i++) {
    if (parts1[i] < parts2[i]) return -1;
    if (parts1[i] > parts2[i]) return 1;
  }
  return 0;
}

/// Determines if the What's New modal should be shown.
/// Returns true if:
/// - User has completed onboarding (not a fresh install)
/// - No previous version seen (upgrade from before this feature) OR
/// - Current version is newer than last seen version
bool shouldShowWhatsNew({
  required bool hasSeenOnboarding,
  required String? lastSeenVersion,
  required String currentVersion,
}) {
  // Don't show for fresh installs (users who haven't completed onboarding)
  if (!hasSeenOnboarding) {
    return false;
  }

  // Show if no version recorded (upgrade from before this feature)
  if (lastSeenVersion == null) {
    return true;
  }

  // Show if current version is newer than last seen
  return compareVersions(currentVersion, lastSeenVersion) > 0;
}
