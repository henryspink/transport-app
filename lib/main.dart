import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:system_theme/system_theme.dart';

// import 'pages/raw.dart';
// import 'pages/home.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemTheme.fallbackColor = Colors.red;
  await SystemTheme.accentColor.load();

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
    return MaterialApp(
      title: 'PTV Transport App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: SystemTheme.accentColor.accent),
        useMaterial3: true,
      ),
      home: const TransportApp(
        title: 'Transport App'
      ),
    );
  }
}
