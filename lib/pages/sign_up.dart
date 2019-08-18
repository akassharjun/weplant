import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_plant/model/user.dart';
import 'package:we_plant/pages/home.dart';

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

  ScreenScaler scaler = ScreenScaler();
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
      clubName: dropdownOption,
      createdBy: 'Admin',
      createdAt: '',
      updatedAt: '',
      updatedBy: 'Admin',
    );

    Future<http.Response> response = http.post(
      'http://192.168.1.6:8080/api/v1/users',
      headers: {'content-type': 'application/json'},
      body: user.toJson(),
    );

    print(user.toJson());

    response.then((onValue) async {
//      var value = json.decode(onValue.body.toString());

      User user = User.fromJson(onValue.body.toString());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userID', user.id);
      await prefs.setString('clubName', user.clubName);
      await prefs.setString('email', user.email);
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushNamed(context, HomePage.ROUTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    scaler = ScreenScaler()..init(context);

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
                  SizedBox(height: scaler.getHeight(2)),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: "Enter your name",
                      contentPadding: EdgeInsets.fromLTRB(
                        scaler.getWidth(3),
                        scaler.getHeight(2),
                        scaler.getWidth(3),
                        scaler.getHeight(2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: scaler.getHeight(2)),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Enter your email address",
                      contentPadding: EdgeInsets.fromLTRB(
                        scaler.getWidth(3),
                        scaler.getHeight(2),
                        scaler.getWidth(3),
                        scaler.getHeight(2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    validator: (value) {
                      if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: scaler.getHeight(2)),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Enter your password",
                      contentPadding: EdgeInsets.fromLTRB(
                        scaler.getWidth(3),
                        scaler.getHeight(2),
                        scaler.getWidth(3),
                        scaler.getHeight(2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Passwords cannot be empty!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: scaler.getHeight(2)),
                  TextFormField(
                    style: TextStyle(fontSize: scaler.getTextSize(11.5)),
                    decoration: InputDecoration(
                      labelText: "Enter your password again",
                      contentPadding: EdgeInsets.fromLTRB(
                        scaler.getWidth(3),
                        scaler.getHeight(2),
                        scaler.getWidth(3),
                        scaler.getHeight(2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: scaler.getHeight(2)),
                  isClubSelected
                      ? TextFormField(
                          controller: _clubNameController,
                          decoration: InputDecoration(
                            labelText: "Enter the name of your $dropdownOption",
                            contentPadding: EdgeInsets.fromLTRB(
                              scaler.getWidth(3),
                              scaler.getHeight(2),
                              scaler.getWidth(3),
                              scaler.getHeight(2),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        )
                      : Container(),
                  isClubSelected
                      ? SizedBox(height: scaler.getHeight(2))
                      : Container(),
                  SizedBox(
                    width: double.infinity,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                          scaler.getWidth(3),
                          scaler.getHeight(0.5),
                          scaler.getWidth(3),
                          scaler.getHeight(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownOption,
                          items: dropdownOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
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
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: signUserUp,
                        padding: EdgeInsets.all(12),
                        color: Colors.green,
                        child: Text('SIGN UP',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
