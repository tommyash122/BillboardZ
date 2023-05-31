import 'package:flutter/material.dart';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginForm();
  }
}

class _LoginForm extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _firebase = FirebaseAuth.instance;

  final _enteredEmail = TextEditingController();
  final _enteredpassword = TextEditingController();

  bool _passwordNotVisible = true;
  bool _isAuthenticating = false;

  @override
  void dispose() {
    _enteredEmail.dispose();
    _enteredpassword.dispose();
    super.dispose();
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail.text.trim(),
          password: _enteredpassword.text.trim());
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.code == 'user-not-found'
              ? 'No user found for that email.'
              : error.code == 'wrong-password'
                  ? 'Wrong password provided for that user.'
                  : 'Authentication failed.'),
        ),
      );

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email field
          TextFormField(
            controller: _enteredEmail,
            decoration: const InputDecoration(
              labelText: 'Email Address',
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty ||
                  !EmailValidator.validate(value)) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
          ),

          // Password field
          TextFormField(
            controller: _enteredpassword,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _passwordNotVisible = !_passwordNotVisible;
                  });
                },
                icon: const Icon(Icons.visibility),
              ),
            ),
            obscureText: _passwordNotVisible,
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return 'Please enter a 6 letter password at least.';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),

          if (_isAuthenticating) const CircularProgressIndicator(),

          // Submit button
          if (!_isAuthenticating)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer),
              onPressed: _submit,
              child: const Text('Login'),
            ),
        ],
      ),
    );
  }
}
