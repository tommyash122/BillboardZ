import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:billboardz/screens/widgets/login_form.dart';
import 'package:billboardz/screens/widgets/oAuth_row.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.showRegisterScreen});

  final VoidCallback showRegisterScreen;

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 55),
                child: Text(
                  'BillboardZ',
                  style: GoogleFonts.merriweather(
                      letterSpacing: 4,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 50),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 20, right: 20),
                width: 200,
                // app image logo
                child: Image.asset('assets/images/digital.png'),
              ),
              const Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child:
                      // login form
                      Padding(padding: EdgeInsets.all(16), child: LoginForm()),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // or continue with
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
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
              const SizedBox(
                height: 25,
              ),

              // google, apple and facebook sign in buttons
              const OAuthRow(),

              const SizedBox(
                height: 25,
              ),

              // Not a member? Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?',
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: widget.showRegisterScreen,
                    child: Text(
                      'Register now.',
                      style: TextStyle(color: Colors.blue.shade300),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
