import 'package:billboardz/screens/owner_home_screen.dart';
import 'package:billboardz/screens/owner_my_list.dart';
import 'package:billboardz/screens/seeker_home_screen.dart';
import 'package:billboardz/screens/widgets/add_listing_form.dart';
import 'package:billboardz/screens/widgets/google_btm_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class OwnerNavScreen extends StatefulWidget {
  const OwnerNavScreen({Key? key}) : super(key: key);

  @override
  State<OwnerNavScreen> createState() => _OwnerNavScreenState();
}

class _OwnerNavScreenState extends State<OwnerNavScreen> {
  String showScreen = 'home';
  String userType = 'Billboard Seeker';

  void handleButtonPressed(String screen) {
    setState(() {
      showScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection('users').doc(userId);

    doc.get().then((value) {
      if (value.exists) {
        final type = value.data()!['user_type'];

        setState(() {
          userType = type;
        });
      }
    });

    final Map<String, Widget> screens = {
      'home': const OwnerHomeScreen(),
      'add': const AddListingForm(),
      'my_list': const OwnerMyList(),
      'search': const Center(child: Text('Search')),
    };

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          color: Theme.of(context).colorScheme.onPrimary,
          icon: const Icon(Icons.menu_sharp),
          onPressed: () {},
        ),
        title: const Text('BillboardZ'),
        titleTextStyle: GoogleFonts.merriweather(
            color: Theme.of(context).colorScheme.onPrimary, fontSize: 22),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      ),
      bottomNavigationBar: GoogleBtmNavbar(
        onAddPressed: () => handleButtonPressed('add'),
        onHomePressed: () => handleButtonPressed('home'),
        onLikedPressed: () => handleButtonPressed('my_list'),
        onSearchPressed: () => handleButtonPressed('search'),
      ),
      body: screens[showScreen] ?? const SizedBox(),
    );
  }
}
