import 'package:flutter/material.dart';

import 'package:billboardz/screens/widgets/square_auth_btn.dart';
import 'package:billboardz/sevices/google_auth_service.dart';

class OAuthRow extends StatelessWidget {
  const OAuthRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // google button
        SquareAuthButton(
          imagePath: 'assets/images/google.png',
          onTap: () => GoogleAuthService().signInWithGoogle(),
        ),

        const SizedBox(width: 20),

        // facebook button
        SquareAuthButton(
          imagePath: 'assets/images/facebook.png',
          onTap: () {}, // TODO later
        ),

        const SizedBox(width: 20),

        // apple button
        SquareAuthButton(
          imagePath: 'assets/images/apple-logo.png',
          onTap: () {}, // TODO later
        )
      ],
    );
  }
}
