import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'dart:developer';

import '../elements/login_button.dart';
import '../elements/text_field.dart';
import '../elements/square_tile.dart';
import '../elements/alert.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void signIn() async {
    log("sign in");
    try {
      showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));
      await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );
      log("signed in");
      if (!mounted) return;
      log("popped");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        showDialog(
          context: context,
          builder: (context) => const LoginAlert(message: 'No user found for that email.')
        );
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        showDialog(
          context: context,
          builder: (context) => const LoginAlert(message: 'Inputted password is incorrect.')
        );
      } else {
        log(e.toString());
        showDialog(
          context: context,
          builder: (context) => LoginAlert(message: e.message ?? 'An error occurred while logging in')
        );
      
      }
    }
  }

  void register() async {
    log("move to register page");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  void forgotPassword() {
    log("forgot password");
  }

  void signInWithGoogle() {
    log("google");
  }

  void signInWithApple() {
    log("apple");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // const Icon(
                //   Icons.train,
                //   size: 100,
                // ),
                Column(
                  children: [
                    Image.asset("assets/images/train.png", height: 200),
                    Text("TRANSPORT APP", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                LoginTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                LoginTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: forgotPassword,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                LoginButton(
                  onTap: signIn,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: signInWithGoogle,
                      child: const SquareTile(imagePath: 'assets/images/google.png')
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: signInWithApple,
                      child: const SquareTile(imagePath: 'assets/images/apple.png')
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: register,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}