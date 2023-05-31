import 'package:billboardz/screens/login_screen.dart';
import 'package:billboardz/screens/register_screen.dart';

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Initially, show the login screen
  bool showLoginScreen = true;

  void toggleAuthScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(showRegisterScreen: toggleAuthScreens);
    } else {
      return RegisterScreen(showLoginScreen: toggleAuthScreens);
    }
  }
}
