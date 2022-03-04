// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, avoid_print, unnecessary_brace_in_string_interps, prefer_final_fields, must_be_immutable, deprecated_member_use, prefer_const_constructors_in_immutables, unrelated_type_equality_checks

import 'package:fingerprint_auth_example/screens/auth/signup_screen.dart';
import 'package:fingerprint_auth_example/screens/home_screen.dart';
import 'package:fingerprint_auth_example/services/auth_handler.dart';
import 'package:fingerprint_auth_example/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isloading = false;
  bool isFacebookLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
        title: Text('Sign In'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SIGN IN',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              _commonTextField(controller: _emailController, lable: 'Email'),
              SizedBox(height: 20),
              _commonTextField(
                  controller: _passwordController,
                  lable: 'Password',
                  obscureText: true),
              SizedBox(height: 20),
              MaterialButton(
                color: Colors.deepPurpleAccent,
                shape: StadiumBorder(),
                onPressed: () async {
                  setState(() {
                    isloading = true;
                  });
                  if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    dynamic _result = await _authService.signInWithEmailPass(
                        email: _emailController.text,
                        password: _passwordController.text);
                    if (_result == AuthResultStatus.successful) {
                      _emailController.clear();
                      _passwordController.clear();
                      setState(() {
                        isloading = false;
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ));
                      print('signed in');
                    } else {
                      setState(() {
                        isloading = false;
                      });
                      print(AuthHandler.exceptionMessage(authStatus: _result));
                      _scaffoldKey.currentState?.showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "${AuthHandler.exceptionMessage(authStatus: _result)}",
                          ),
                        ),
                      );
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
                    : Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                color: Colors.deepPurpleAccent,
                shape: StadiumBorder(),
                onPressed: () async {
                  var res = await _authService.googleSignIn(context);
                  if (res == AuthResultStatus.successful) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                  } else {
                    print(AuthHandler.exceptionMessage(authStatus: res));
                  }
                },
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                color: Colors.deepPurpleAccent,
                shape: StadiumBorder(),
                onPressed: () async {
                  setState(() {
                    isFacebookLogin = true;
                  });
                  await AuthService().facebookLogin(context);
                },
                child: isFacebookLogin
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator())
                    : Text('Sign In with Facebook',
                        style: TextStyle(color: Colors.white)),
              ),
              // MaterialButton(
              //   color: Colors.deepPurpleAccent,
              //   shape: StadiumBorder(),
              //   onPressed: () async {
              //     await AuthService().login_twitter(context);
              //   },
              //   child: Text('Sign In with Twitter',
              //       style: TextStyle(color: Colors.white)),
              // ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ));
                },
                child: Text('Sign Up',
                    style: TextStyle(color: Colors.deepPurpleAccent)),
              ),
            ],
          ),
        )),
      ),
    );
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
