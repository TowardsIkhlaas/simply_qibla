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
