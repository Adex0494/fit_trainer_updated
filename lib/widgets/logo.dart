import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/fitTrainerLogo.png');
    // Image image = Image(
    //   image: assetImage,
    //   width: 100.0,
    //   height: 100.0,
    // );
    return CircleAvatar(
        radius: 75,
        backgroundImage: assetImage,
        backgroundColor: Colors.white,
    );
  }
}
