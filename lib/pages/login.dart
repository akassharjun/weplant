import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_plant/model/user.dart';
import 'package:we_plant/widgets/app_logo.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  static const String ROUTE = 'login';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ScreenScaler scaler;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String email = '';
  String password = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void validateLoginCredentials() {
    if (_formKey.currentState.validate()) {
      email = _emailController.text;
      password = _passwordController.text;

      print(password);
      print(email);

      User user = User(
        id: 0,
        email: email,
        password: password,
        fullName: '',
        clubName: '',
        createdAt: '',
        createdBy: '',
        updatedAt: '',
        updatedBy: '',
      );
      Future<http.Response> response = http.post(
        'http://192.168.1.6:8080/api/v1/login',
        headers: {'content-type': 'application/json'},
        body: user.toJson(),
      );

      response.then((onValue) async {
        if (onValue.body.toString().isEmpty) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Invalid Login Credentials")));
        } else {
          User user = User.fromJson(onValue.body.toString());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userID', user.id);
          await prefs.setString('clubName', user.clubName);
          await prefs.setString('email', user.email);

          await prefs.setBool('isLoggedIn', true);

          Navigator.pushNamed(context, HomePage.ROUTE);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    scaler = ScreenScaler()..init(context);

    final emailTextField = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofocus: false,
      style: TextStyle(
        fontSize: scaler.getTextSize(12),
      ),
      decoration: InputDecoration(
        hintText: 'Enter your email here',
        contentPadding: EdgeInsets.fromLTRB(
          scaler.getWidth(3),
          scaler.getHeight(2),
          scaler.getWidth(3),
          scaler.getHeight(2),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      validator: (value) {
        if (!value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );

    final passwordTextField = TextFormField(
      controller: _passwordController,
      autofocus: false,
      obscureText: true,
      onSaved: (String value) => password = value,
      style: TextStyle(
        fontSize: scaler.getTextSize(12),
      ),
      decoration: InputDecoration(
        hintText: 'Enter your password here',
        contentPadding: EdgeInsets.fromLTRB(
          scaler.getWidth(3),
          scaler.getHeight(2),
          scaler.getWidth(3),
          scaler.getHeight(2),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {
        validateLoginCredentials();
//          Navigator.of(context).pushNamed(HomePage.tag);
      },
      color: Colors.green,
      child: Text('LOGIN', style: TextStyle(color: Colors.white)),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    scaler = ScreenScaler()..init(context);

    return Scaffold(
      backgroundColor: Color(0xFFfcfcfc),
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                left: scaler.getWidth(6),
                right: scaler.getWidth(6),
              ),
              children: <Widget>[
                Container(child: AppLogo()),
                SizedBox(height: scaler.getHeight(15)),
                emailTextField,
                SizedBox(height: scaler.getHeight(2)),
                passwordTextField,
                SizedBox(height: scaler.getHeight(5)),
                loginButton,
                forgotLabel
              ],
            ),
          ),
        ),
      ),
    );
  }
}
