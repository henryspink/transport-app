import 'package:flutter/material.dart';

class LoginAlert extends StatelessWidget {
  final String message;

  const LoginAlert({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("An error occurred while logging in"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {Navigator.pop(context);},
          child: const Text("Try Again"),
        ),
      ],
    );
  }
} 