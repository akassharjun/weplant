import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_plant/model/user.dart';
import 'package:we_plant/widgets/app_logo.dart';

import '../constants.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  static const String ROUTE = 'login';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variables
  ScreenScaler scaler;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String email = '';
  String password = '';

  bool isLoading = false;

  // Functions

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper functions

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Invalid Credientials"),
          content: new Text("Your email/password is incorrect"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _saveSharedPreferences(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userID', user.id);
    await prefs.setString('clubName', user.clubName);
    await prefs.setString('email', user.email);
    await prefs.setBool('isLoggedIn', true);
  }

  Future _validateLoginCredentials() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      email = _emailController.text;
      password = _passwordController.text;

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

      http.Response response = await http.post(
        Constants.URL_USER,
        headers: {'content-type': 'application/json'},
        body: user.toJson(),
      );

      if (response.body.toString().isNotEmpty) {
        User user = User.fromJson(response.body.toString());

        _saveSharedPreferences(user);
        Navigator.pushNamed(context, HomePage.ROUTE);
      } else {
        _showDialog();
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Widgets

  TextFormField _buildEmailTextField() {
    return TextFormField(
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
  }

  Form _buildForm() {
    return Form(
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
          _buildEmailTextField(),
          SizedBox(height: scaler.getHeight(2)),
          _buildForgotPasswordLabel(),
          SizedBox(height: scaler.getHeight(5)),
          _buildLoginButton(),
          _buildForgotPasswordLabel()
        ],
      ),
    );
  }

  FlatButton _buildForgotPasswordLabel() {
    return FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );
  }

  RaisedButton _buildLoginButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {
        _validateLoginCredentials();
//          Navigator.of(context).pushNamed(HomePage.tag);
      },
      color: Colors.green,
      child: Text('LOGIN', style: TextStyle(color: Colors.white)),
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
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
  }

  @override
  Widget build(BuildContext context) {
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
          child: isLoading ? CircularProgressIndicator() : _buildForm(),
        ),
      ),
    );
  }
}
