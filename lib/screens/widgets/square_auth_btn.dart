import 'package:flutter/material.dart';

class SquareAuthButton extends StatelessWidget {
  const SquareAuthButton({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  final String imagePath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(22),
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          child: Image.asset(
            imagePath,
            height: 22,
          ),
        ));
  }
}
