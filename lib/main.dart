import 'package:flutter/material.dart';

// import 'pages/raw.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PTV Transport App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      // home: const RawResponse(title: 'Transport App'),
      home: const TestDetails(title: 'Transport App'),
    );
  }
}
