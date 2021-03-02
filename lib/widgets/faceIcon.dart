import 'package:flutter/material.dart';

class FaceIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/faceIcon.png');
    // Image image = Image(
    //   image: assetImage,
    //   width: 150.0,
    //   height: 150.0,
    // );
    return CircleAvatar(
      radius: 70,
      backgroundImage: assetImage,
    );
  }
}