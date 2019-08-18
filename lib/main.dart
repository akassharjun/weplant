import 'package:flutter/material.dart';
import 'package:we_plant/pages/home.dart';
import 'package:we_plant/pages/login.dart';
import 'package:we_plant/pages/plant_information.dart';
import 'package:we_plant/pages/sign_up.dart';
import 'package:we_plant/pages/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      initialRoute: '/',
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.green,
      ),
      routes: {
        PlantInformationScreen.ROUTE: (BuildContext context) =>
            PlantInformationScreen(),
        SignUpPage.ROUTE: (BuildContext context) => SignUpPage(),
        LoginPage.ROUTE: (BuildContext context) => LoginPage(),
        HomePage.ROUTE: (BuildContext context) => HomePage()
      },
    );
  }
}
