import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'pages/auth/login.dart';
import 'app.dart';

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const TransportApp(title: 'Transport App');
        } else {
          return const LoginPage();
        }
      }
    );
  }
}