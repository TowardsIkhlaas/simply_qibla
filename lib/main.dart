import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simply_qibla/pages/map_page.dart';
import 'package:simply_qibla/theme/theme.dart';

Future main() async {
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
      darkTheme: AppThemes.darkTheme,
      home: const MapPage(),
    );
  }
}
