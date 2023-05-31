import 'package:flutter/material.dart';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterForm();
  }
}

class _RegisterForm extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _firebase = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  final userTypes = ['Billboard Seeker', 'Billboard Owner'];
  final _enteredEmail = TextEditingController();
  final _enteredPassword = TextEditingController();
  final _enteredConfirmPassword = TextEditingController();
  final _enteredFirstName = TextEditingController();
  final _enteredLastName = TextEditingController();
  final _enteredPhoneNumber = TextEditingController();
  final _enteredCity = TextEditingController();
  String? userType = 'Billboard Seeker';

  bool _passwordNotVisible = true;
  bool _confirmPasswordNotVisible = true;
  bool _isAuthenticating = false;

  @override
  void dispose() {
    _enteredEmail.dispose();
    _enteredPassword.dispose();
    _enteredConfirmPassword.dispose();
    _enteredFirstName.dispose();
    _enteredLastName.dispose();
    _enteredPhoneNumber.dispose();
    _enteredCity.dispose();
    super.dispose();
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    if (_enteredPassword.text.trim() != _enteredConfirmPassword.text.trim()) {
      showScafMessage('Passwords do not match.');
    }
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail.text.trim(),
          password: _enteredPassword.text.trim());

      // add user details
      addUserDetails(
          userCredentials.user!.uid,
          _enteredEmail.text.trim(),
          _enteredFirstName.text.trim(),
          _enteredLastName.text.trim(),
          int.parse(_enteredPhoneNumber.text.trim()),
          _enteredCity.text.trim(),
          userType.toString());
    } on FirebaseAuthException catch (error) {
      showScafMessage(error.code);
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future addUserDetails(String userId, String email, String firstName,
      String lastName, int phoneNumber, String city, String userType) async {
    await _fireStore.collection('users').doc(userId).set(
      {
        'userId': userId,
        'createdAt': Timestamp.now(),
        'user_type': userType,
        'user_info': [
          {
            'Email': email,
            'first_name': firstName,
            'last_name': lastName,
            'phone_number': phoneNumber,
            'city': city,
          }
        ]
      },
    );
  }

  void showScafMessage(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );

    return;
  }

  DropdownMenuItem<String> buildTypes(String type) {
    return DropdownMenuItem(
      value: type,
      child: Text(
        type,
        // style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // User type
              const Text('User Type:'),
              DropdownButton(
                  value: userType,
                  items: userTypes.map(buildTypes).toList(),
                  onChanged: (val) => setState(() {
                        userType = val!;
                      })),
            ],
          ),

          // First name
          TextFormField(
            controller: _enteredFirstName,
            decoration: const InputDecoration(
              labelText: 'First name',
            ),
            keyboardType: TextInputType.name,
            autocorrect: false,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your first name.';
              }
              return null;
            },
          ),

          // Last name
          TextFormField(
            controller: _enteredLastName,
            decoration: const InputDecoration(
              labelText: 'Last name',
            ),
            keyboardType: TextInputType.name,
            autocorrect: false,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your last name.';
              }
              return null;
            },
          ),

          // Phone number
          TextFormField(
            controller: _enteredPhoneNumber,
            decoration: const InputDecoration(
              labelText: 'Phone number',
            ),
            keyboardType: TextInputType.number,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null || value.trim().isEmpty || value.length < 10) {
                return 'Please enter a valid phone number.';
              }
              return null;
            },
          ),

          // City
          TextFormField(
            controller: _enteredCity,
            decoration: const InputDecoration(
              labelText: 'City',
            ),
            keyboardType: TextInputType.text,
            autocorrect: false,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your city of residence.';
              }
              return null;
            },
          ),

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
            controller: _enteredPassword,
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

          // Confirm password field
          TextFormField(
            controller: _enteredConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _confirmPasswordNotVisible = !_confirmPasswordNotVisible;
                  });
                },
                icon: const Icon(Icons.visibility),
              ),
            ),
            obscureText: _confirmPasswordNotVisible,
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

          // Submit and clear buttons
          if (!_isAuthenticating)
            Row(
              children: [
                Expanded(
                  child: IconButton(
                      iconSize: 25,
                      icon: const Icon(Icons.clear_all),
                      onPressed: () {
                        setState(() {
                          userType = 'Billboard Seeker';
                          _enteredFirstName.clear();
                          _enteredLastName.clear();
                          _enteredPhoneNumber.clear();
                          _enteredCity.clear();
                          _enteredEmail.clear();
                          _enteredPassword.clear();
                          _enteredConfirmPassword.clear();
                        });
                      }),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer),
                    onPressed: _submit,
                    child: const Text('Sign Up'),
                  ),
                ),
                const Expanded(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
