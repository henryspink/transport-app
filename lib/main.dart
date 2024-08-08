import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:developer';

import 'package:system_theme/system_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transport_app/auth.dart';
import 'firebase_options.dart';

// import 'pages/raw.dart';
// import 'pages/home.dart';
// import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  log('Starting app...');
  SystemTheme.fallbackColor = Colors.red;
  await SystemTheme.accentColor.load();
  log('starting firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log('firebase started');
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: SystemTheme.accentColor.accent,
    )
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: const Color(0x00000000)));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PTV Transport App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: SystemTheme.accentColor.accent),
        useMaterial3: true,
      ),
      home: const AuthApp()
    );
  }
}
