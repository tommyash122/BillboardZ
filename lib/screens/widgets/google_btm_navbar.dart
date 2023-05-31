import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GoogleBtmNavbar extends StatelessWidget {
  const GoogleBtmNavbar({
    super.key,
    required this.onHomePressed,
    required this.onAddPressed,
    required this.onSearchPressed,
    required this.onLikedPressed,
  });

  final VoidCallback onAddPressed; // Add callback function
  final VoidCallback onHomePressed; // Home callback function
  final VoidCallback onLikedPressed; // Liked callback function
  final VoidCallback onSearchPressed;
  // Search callback function
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: GNav(
          gap: 8,
          backgroundColor: Theme.of(context).colorScheme.primary,
          color: Colors.white,
          activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
          tabBackgroundColor:
              Theme.of(context).colorScheme.onSecondary.withOpacity(0.86),
          padding: const EdgeInsets.all(16),
          tabs: [
            GButton(
              text: 'Home',
              icon: Icons.home_rounded,
              onPressed: onHomePressed,
            ),
            GButton(
              text: 'my_listings',
              icon: Icons.list_alt,
              onPressed: onLikedPressed,
            ),
            GButton(
              text: 'Search',
              icon: Icons.search,
              onPressed: onSearchPressed,
            ),
            GButton(
              text: 'Add',
              icon: Icons.add_circle_outline,
              onPressed: onAddPressed,
            ),
          ],
        ),
      ),
    );
  }
}
