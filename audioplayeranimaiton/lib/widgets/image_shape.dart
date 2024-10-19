import 'package:flutter/material.dart';

class ImageShape extends StatelessWidget {
  const ImageShape({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          image: const DecorationImage(
              image: AssetImage(
            'assets/Images/hagh.jpg',
          ))),
    );
  }
}