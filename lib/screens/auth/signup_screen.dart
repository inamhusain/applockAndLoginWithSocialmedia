// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, avoid_print, unnecessary_brace_in_string_interps, prefer_final_fields, must_be_immutable, unnecessary_null_comparison, deprecated_member_use

import 'dart:async';
import 'package:fingerprint_auth_example/screens/auth/signin_screen.dart';
import 'package:fingerprint_auth_example/screens/home_screen.dart';
import 'package:fingerprint_auth_example/services/auth_handler.dart';
import 'package:fingerprint_auth_example/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  bool isloading = false;
  // TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Sign Up'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SIGN UP',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            _commonTextField(controller: _emailController, lable: "Email"),
            SizedBox(height: 20),
            _commonTextField(
                controller: _passwordController,
                lable: "Password",
                obscureText: true),
            SizedBox(height: 20),
            MaterialButton(
              color: Colors.deepPurpleAccent,
              shape: StadiumBorder(),
              onPressed: () async {
                if (_emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  dynamic result = await _authService.createNewUser(
                      email: _emailController.text,
                      password: _passwordController.text);

                  if (result == AuthResultStatus.successful) {
                    _emailController.clear();
                    _passwordController.clear();

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                  } else {
                    setState(() {
                      isloading = false;
                    });
                    _scaffoldKey.currentState?.showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(
                            "${AuthHandler.exceptionMessage(authStatus: result)}")));
                  }
                } else {
                  setState(() {
                    isloading = false;
                  });
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Please Enter value')));
                }
              },
              child: isloading == true
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : Text('Sign Up', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                navigateToSignIn();
              },
              child: Text('Sign In',
                  style: TextStyle(color: Colors.deepPurpleAccent)),
            ),
          ],
        )),
      ),
    );
  }

  navigateToSignIn() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ));
  }

  _commonTextField({lable, controller, obscureText}) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      cursorColor: Colors.deepPurpleAccent,
      decoration: InputDecoration(
        label: Text(lable),
        labelStyle: TextStyle(color: Colors.deepPurpleAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.deepPurpleAccent,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
