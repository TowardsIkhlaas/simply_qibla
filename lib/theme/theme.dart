import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromRGBO(21, 18, 19, 1.0),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: -2,
      ),
      titleMedium: TextStyle(
        fontSize: 24.0,
        letterSpacing: -1,
      ),
      titleSmall: TextStyle(
        fontSize: 18.0,
        letterSpacing: -0.50,
      ),
      bodyLarge: TextStyle(
        letterSpacing: -0.25,
      ),
      bodyMedium: TextStyle(
        letterSpacing: -0.25,
      ),
      bodySmall: TextStyle(
        letterSpacing: -0.25,
      ),
      labelLarge: TextStyle(
        letterSpacing: -0.25,
      ),
      labelMedium: TextStyle(
        letterSpacing: -0.25,
      ),
      labelSmall: TextStyle(
        letterSpacing: -0.25,
      ),
    ),
  );

  static const Color githubPrimaryColor = Colors.white;
  static const Color githubSecondaryColor = Color.fromRGBO(14, 17, 23, 1.0);
  static const Color donationServicePrimaryColor = Colors.white;
  static const Color donationServiceSecondaryColor = Color.fromRGBO(83, 183, 248, 1.0);
}
