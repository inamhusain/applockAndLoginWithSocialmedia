// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:fingerprint_auth_example/api/local_auth_api.dart';
import 'package:fingerprint_auth_example/helper/sharedpreference_halper.dart';
import 'package:fingerprint_auth_example/screens/auth/signin_screen.dart';
import 'package:fingerprint_auth_example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  ValueNotifier<bool> isBiometricEnable = ValueNotifier<bool>(false);

  @override
  void initState() {
    isSetPAssword();
    getBiometricsIsAvaiable();

    super.initState();
  }

  fingerprintPopUp() async {
    final isAuthenticated = await LocalAuthApi.authenticate();

    if (isAuthenticated) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
  }

  isSetPAssword() async {
    if (await SharedPreferenceHelper().getPassword() == null ||
        await SharedPreferenceHelper().getPassword() == '') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ));
    }
  }

  getBiometricsIsAvaiable() async {
    isBiometricEnable.value = await SharedPreferenceHelper().getBiometrics();
    if (isBiometricEnable.value == true) {
      fingerprintPopUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'App lock'.toUpperCase(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.deepPurpleAccent),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              keyboardType: TextInputType.number,
              cursorColor: Colors.deepPurpleAccent,
              style: TextStyle(color: Colors.black, letterSpacing: 2),
              decoration: InputDecoration(
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
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () async {
                if (controller.text.isEmpty ||
                    controller.text == null ||
                    controller.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please Enter password"),
                  ));
                } else if (controller.text.length <= 5) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Password length must be 6"),
                  ));
                } else {
                  if (await SharedPreferenceHelper().getPassword() ==
                      controller.text) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ));
                    controller.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Password not match"),
                    ));
                  }
                }
              },
              color: Colors.deepPurpleAccent,
              shape: StadiumBorder(),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: isBiometricEnable,
              builder: (BuildContext context, dynamic value, Widget? child) {
                if (isBiometricEnable.value == true) {
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Login With Biometrics',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      IconButton(
                          onPressed: () async {
                            final isAuthenticated =
                                await LocalAuthApi.authenticate();

                            if (isAuthenticated) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.lock_open_outlined,
                            size: 30,
                          ))
                    ],
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
