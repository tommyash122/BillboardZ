import 'package:billboardz/screens/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.showLoginScreen});

  final VoidCallback showLoginScreen;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  'Welcome aboardZ!',
                  style: GoogleFonts.merriweather(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 30),
                ),
              ),

              const Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child:
                      // register form
                      Padding(
                          padding: EdgeInsets.all(16), child: RegisterForm()),
                ),
              ),
              const SizedBox(
                height: 5,
              ),

              // Not a member? Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('I\'m already a member.',
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: widget.showLoginScreen,
                    child: Text(
                      'Login Instead',
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
