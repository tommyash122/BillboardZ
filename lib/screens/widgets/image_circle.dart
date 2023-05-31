import 'package:flutter/material.dart';

import 'package:billboardz/screens/widgets/image_full_screen.dart';

class ImageCircle extends StatelessWidget {
  final String imageUrl;

  const ImageCircle({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageFullScreen(imageUrl: imageUrl),
        ),
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey,
        foregroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}
