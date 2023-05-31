import 'package:billboardz/screens/auth_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:billboardz/screens/seeker_home_screen.dart';
import 'package:billboardz/screens/owner_nav_screen.dart';
import 'package:billboardz/screens/splash.dart';

import 'firebase_options.dart';

// TODO: check dark mode theme responsiveness
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Initial Page',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 64, 0, 77)),
      ),
      home: StreamBuilder(
        stream: user.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            // TODO: Handle user type navigation

            return const OwnerNavScreen();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
