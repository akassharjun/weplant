import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_plant/model/user.dart';
import 'package:we_plant/pages/home.dart';

import '../constants.dart';

class SignUpPage extends StatefulWidget {
  static const ROUTE = 'signup';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String fullName = '';
  String password = '';
  String clubName = '';
  String dropdownOption = "Rotaract Club";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _clubNameController = TextEditingController();

  static ScreenScaler scaler = ScreenScaler();
  bool isClubSelected = true;

  List<String> dropdownOptions = [
    'Rotaract Club',
    'Rotary Club',
    'Interact Club',
    'School',
    'Campus',
    'Individual'
  ];

  void signUserUp() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    User user = User(
      id: 0,
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      clubName: _clubNameController.text,
      createdBy: 'Admin',
      updatedBy: 'Admin',
    );

    Future<http.Response> response = http.post(
      Constants.URL_USER,
      headers: {'content-type': 'application/json'},
      body: user.toJson(),
    );

    print(user.toJson());

    response.then((onValue) async {
      User user = User.fromJson(onValue.body.toString());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userID', user.id);
      await prefs.setString('clubName', user.clubName);
      await prefs.setString('email', user.email);
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushNamed(context, HomePage.ROUTE);
    });
  }

  final TextStyle _formTextStyle = TextStyle(fontSize: scaler.getTextSize(12));

  @override
  Widget build(BuildContext context) {
    scaler = ScreenScaler()..init(context);

    final SizedBox _spacer = SizedBox(height: scaler.getHeight(2));

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              child: Column(
                children: <Widget>[
                  _spacer,
                  _buildNameTextField(),
                  _spacer,
                  _buildEmailTextField(),
                  _spacer,
                  _buildPasswordTextField(),
                  _spacer,
                  _buildConfirmPasswordTextField(),
                  _spacer,
                  _buildClubNameTextField(),
                  isClubSelected ? _spacer : Container(),
                  _buildDropdownOptions(),
                  _buildSignUpButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scaler.getTextSize(15)),
          ),
          onPressed: signUserUp,
          padding: EdgeInsets.all(12),
          color: Colors.green,
          child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  SizedBox _buildDropdownOptions() {
    return SizedBox(
      width: double.infinity,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            scaler.getWidth(3),
            scaler.getHeight(-1),
            scaler.getWidth(3),
            scaler.getHeight(-1),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(scaler.getTextSize(18))),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: dropdownOption,
            items: dropdownOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: _formTextStyle,
                ),
              );
            }).toList(),
            onChanged: (String newValue) {
              if (newValue == "School" ||
                  newValue == "Individual" ||
                  newValue == "Campus") {
                isClubSelected = false;
              } else {
                isClubSelected = true;
              }
              setState(() {
                dropdownOption = newValue;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildClubNameTextField() {
    return isClubSelected
        ? TextFormField(
            controller: _clubNameController,
            style: _formTextStyle,
            decoration: InputDecoration(
              labelText: "Enter the name of your $dropdownOption",
              contentPadding: EdgeInsets.fromLTRB(
                scaler.getWidth(3),
                scaler.getHeight(2),
                scaler.getWidth(3),
                scaler.getHeight(2),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(scaler.getTextSize(15))),
            ),
          )
        : Container();
  }

  TextFormField _buildConfirmPasswordTextField() {
    return TextFormField(
      obscureText: true,
      style: _formTextStyle,
      decoration: InputDecoration(
        labelText: "Enter your password again",
        contentPadding: EdgeInsets.fromLTRB(
          scaler.getWidth(3),
          scaler.getHeight(2),
          scaler.getWidth(3),
          scaler.getHeight(2),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(scaler.getTextSize(15))),
      ),
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Passwords do not match!';
        }
        return null;
      },
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      style: _formTextStyle,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Enter your password",
        contentPadding: EdgeInsets.fromLTRB(
          scaler.getWidth(3),
          scaler.getHeight(2),
          scaler.getWidth(3),
          scaler.getHeight(2),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(scaler.getTextSize(15))),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Passwords cannot be empty!';
        }
        return null;
      },
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      style: _formTextStyle,
      decoration: InputDecoration(
        labelText: "Enter your email address",
        contentPadding: EdgeInsets.fromLTRB(
          scaler.getWidth(3),
          scaler.getHeight(2),
          scaler.getWidth(3),
          scaler.getHeight(2),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(scaler.getTextSize(15))),
      ),
      validator: (value) {
        if (!value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  TextFormField _buildNameTextField() {
    return TextFormField(
      controller: _fullNameController,
      style: _formTextStyle,
      decoration: InputDecoration(
        labelText: "Enter your name",
        contentPadding: EdgeInsets.fromLTRB(
          scaler.getWidth(3),
          scaler.getHeight(2),
          scaler.getWidth(3),
          scaler.getHeight(2),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(scaler.getTextSize(15))),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
