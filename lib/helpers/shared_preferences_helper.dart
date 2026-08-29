import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getOnboardingStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  return (prefs.getBool('hasSeenOnboarding') ?? false);
}

Future<void> setOnboardingStatus(bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasSeenOnboarding', value);
}

Future<int> getLaunchCount() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();

  int launchCount = prefs.getInt('launchCount') ?? 0;
  launchCount++;
  prefs.setInt('launchCount', launchCount);

  return launchCount;
}

Future<bool> getCompassEnabled() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  return prefs.getBool('compassEnabled') ?? true;
}

Future<void> setCompassEnabled(bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('compassEnabled', value);
}

Future<String> getThemeMode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  return prefs.getString('themeMode') ?? 'system';
}

Future<void> setThemeMode(String mode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeMode', mode);
}

Future<String> getColorMode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  return prefs.getString('colorMode') ?? 'default';
}

Future<void> setColorMode(String mode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('colorMode', mode);
}

Future<String?> getLastSeenVersion() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  return prefs.getString('lastSeenVersion');
}

Future<void> setLastSeenVersion(String version) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastSeenVersion', version);
}

Future<({double lat, double lng})?> getLastLocation() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final List<String>? parts = prefs.getStringList('lastLocation');
  if (parts == null || parts.length != 2) return null;
  final double? latitude = double.tryParse(parts[0]);
  final double? longitude = double.tryParse(parts[1]);
  if (latitude == null || longitude == null) return null;
  return (lat: latitude, lng: longitude);
}

// Single-key write to keep lat/lng atomic across concurrent callers.
Future<void> setLastLocation(double latitude, double longitude) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    'lastLocation',
    <String>['$latitude', '$longitude'],
  );
}
