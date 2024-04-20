import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simply_qibla/pages/map_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simply Qibla',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromRGBO(21, 18, 19, 1.0),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -2,
          ),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
      ),
      home: const MapPage(),
    );
  }
}
