import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_plant/pages/home.dart';
import 'package:we_plant/widgets/app_logo.dart';

import 'login.dart';
import 'sign_up.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE = "splash";

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ScreenScaler scaler;

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    checkIfUserIsLoggedIn();
  }

  Future checkIfUserIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == null) {
      setState(() {
        _visible = true;
      });
    } else {
      Navigator.pushReplacementNamed(context, HomePage.ROUTE);
    }
  }

  @override
  Widget build(BuildContext context) {
    scaler = ScreenScaler()..init(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: scaler.getWidth(50),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: AppLogo(),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _visible
                            ? Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, LoginPage.ROUTE);
                                      },
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text("LOG IN"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, SignUpPage.ROUTE);
                                      },
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text("SIGN UP"),
                                    ),
                                  ),
                                ],
                              )
                            : CircularProgressIndicator(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
