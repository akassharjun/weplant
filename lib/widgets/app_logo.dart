import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

class AppLogo extends StatelessWidget {
  ScreenScaler scaler;

  @override
  Widget build(BuildContext context) {
    scaler = ScreenScaler()..init(context);

    return Column(
      children: <Widget>[
        Container(
          height: scaler.getHeight(18),
          child: Image.asset('assets/plant.png'),
        ),
        Text(
          "WePlant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: scaler.getTextSize(18),
          ),
        )
      ],
    );
  }
}
