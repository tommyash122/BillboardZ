import 'dart:io';

import 'package:billboardz/screens/widgets/assets_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class AddListingForm extends StatefulWidget {
  const AddListingForm({Key? key}) : super(key: key);

  @override
  State<AddListingForm> createState() => _AddListingFormState();
}

class _AddListingFormState extends State<AddListingForm> {
  final _formKey = GlobalKey<FormState>();
  final _fireStore = FirebaseFirestore.instance;
  final docPath = FirebaseFirestore.instance.collection('listings').doc().path;

  File? _selectedFile;
  final _boardTitle = TextEditingController();
  final _contactFirstName = TextEditingController();
  final _contactLastName = TextEditingController();
  final _contctPhoneNumber = TextEditingController();
  final _contctEmail = TextEditingController();
  final _boardCountry = TextEditingController();
  final _boardCity = TextEditingController();
  final _boardStreet = TextEditingController();
  final _boardStreetNumber = TextEditingController();
  final _boardPrice = TextEditingController();
  final _boardScreenTime = TextEditingController();
  final _boardDescription = TextEditingController();
  final List<TextEditingController> _boardResolution = [
    TextEditingController(),
    TextEditingController()
  ];

  bool _isUploading = false;
  String fileUrlDownload = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isUploading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      if (_selectedFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_files')
            .child('docPath=${docPath.toString()}userId=$userId.jpg');

        await storageRef.putFile(_selectedFile!);
        final downloadUrl = await storageRef.getDownloadURL();

        setState(() {
          fileUrlDownload = downloadUrl;
        });
      }

      addBoardDetails(
        _boardTitle.text.trim(),
        _contactFirstName.text.trim(),
        _contactLastName.text.trim(),
        _contctPhoneNumber.text.trim(),
        _contctEmail.text.trim(),
        _boardCountry.text.trim(),
        _boardCity.text.trim(),
        int.parse(_boardStreetNumber.text),
        int.parse(_boardPrice.text),
        int.parse(_boardScreenTime.text),
        int.parse(_boardResolution[0].text),
        int.parse(_boardResolution[1].text),
        _boardDescription.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      showScafMessage(error.code);
    }

    setState(() {
      _isUploading = false;
    });

    showScafMessage('Successfully added');
  }

  Future addBoardDetails(
      String boardTitle,
      String firstName,
      String lastName,
      String phoneNumber,
      String country,
      String city,
      String street,
      int streetNumber,
      int price,
      int screenTime,
      int resolution1,
      int resolution2,
      String description) async {
    await _fireStore.collection('listings').add(
      {
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': Timestamp.now(),
        'listingPath': docPath,
        'fileDownload': fileUrlDownload,
        'details': [
          {
            'board title': boardTitle,
            'contact\'s first name': firstName,
            'contact\'s last name': lastName,
            'contact\'s phone number': phoneNumber,
            'country': city,
            'city': city,
            'street': street,
            'streetNumber': streetNumber,
            'price': price,
            'screenTime': screenTime,
            'board\'s resolution': [resolution1, resolution2],
            'description': description,
          }
        ],
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

  @override
  void dispose() {
    _boardTitle.dispose();
    _contactFirstName.dispose();
    _contactLastName.dispose();
    _contctPhoneNumber.dispose();
    _contctEmail.dispose();
    _boardCountry.dispose();
    _boardCity.dispose();
    _boardStreet.dispose();
    _boardStreetNumber.dispose();
    _boardScreenTime.dispose();
    for (var c in _boardResolution) {
      c.dispose();
    }
    _boardDescription.dispose();
    _boardPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            // Add an image
            AssetsPicker(
              onPickFile: (file) {
                // get the file path from the assets_picker
                _selectedFile = file;
              },
            ),
            // Board title
            TextFormField(
              controller: _boardTitle,
              decoration: const InputDecoration(
                labelText: 'Board title*',
              ),
              keyboardType: TextInputType.name,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please give your board a title.';
                }
                return null;
              },
            ),

            // Contact First name
            TextFormField(
              controller: _contactFirstName,
              decoration: const InputDecoration(
                labelText: 'contact\'s first name*',
              ),
              keyboardType: TextInputType.name,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the contact\'s first name.';
                }
                return null;
              },
            ),

            // Contact Last name
            TextFormField(
              controller: _contactLastName,
              decoration: const InputDecoration(
                labelText: 'contact\'s last name',
              ),
              keyboardType: TextInputType.name,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
            ),

            // Phone number
            TextFormField(
              controller: _contctPhoneNumber,
              decoration: const InputDecoration(
                labelText: 'Phone number*',
              ),
              keyboardType: TextInputType.number,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    value.length < 10) {
                  return 'Please enter a valid phone number.';
                }

                return null;
              },
            ),

            // Email field
            TextFormField(
              controller: _contctEmail,
              decoration: const InputDecoration(
                labelText: 'Email Address*',
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

            // Board's country
            TextFormField(
              controller: _boardCountry,
              decoration: const InputDecoration(
                labelText: 'Country*',
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter in which country the board located.';
                }
                return null;
              },
            ),
            // City
            TextFormField(
              controller: _boardCity,
              decoration: const InputDecoration(
                labelText: 'City*',
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter in which city the board located.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _boardStreet,
              decoration: const InputDecoration(
                labelText: 'Street*',
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter in which street the board located.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _boardStreetNumber,
              decoration: const InputDecoration(
                labelText: 'Street number*',
              ),
              keyboardType: TextInputType.number,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the street number.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _boardPrice,
              decoration: const InputDecoration(
                labelText: 'price*',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the street number.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _boardScreenTime,
              decoration: const InputDecoration(
                labelText: 'Screen time*',
              ),
              keyboardType: TextInputType.number,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the screen time you offer.';
                }
                return null;
              },
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _boardResolution[0],
                    decoration: const InputDecoration(
                      labelText: 'Resolution.1*',
                    ),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the screen time you offer.';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _boardResolution[1],
                    decoration: const InputDecoration(
                      labelText: 'Resolution.2*',
                    ),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the resolution.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            TextFormField(
              controller: _boardDescription,
              decoration: const InputDecoration(
                labelText: 'description',
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
            ),

            const SizedBox(
              height: 12,
            ),

            // // Submit and clear buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: IconButton(
                      iconSize: 25,
                      icon: const Icon(Icons.clear_all),
                      onPressed: () {
                        setState(() {
                          _contactFirstName.clear();
                          _contactLastName.clear();
                          _contctPhoneNumber.clear();
                          _contctEmail.clear();
                          _boardCountry.clear();
                          _boardCity.clear();
                          _boardStreet.clear();
                          _boardStreetNumber.clear();
                          _boardScreenTime.clear();
                          _boardResolution[0].clear();
                          _boardResolution[1].clear();
                        });
                      }),
                ),
                if (_isUploading) const CircularProgressIndicator(),
                if (!_isUploading)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer),
                      onPressed: _submit,
                      child: const Text('Add'),
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
      ),
    );
  }
}
