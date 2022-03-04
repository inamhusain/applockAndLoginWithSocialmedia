import 'dart:io';

import 'package:fingerprint_auth_example/screens/auth/signin_screen.dart';
import 'package:fingerprint_auth_example/screens/setting_screen.dart';
import 'package:fingerprint_auth_example/services/auth_handler.dart';
import 'package:fingerprint_auth_example/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Home Screen'),
        actions: [
          if (Platform.isIOS) ...[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  _navigatToSettingPage(context);
                },
                icon: Icon(CupertinoIcons.settings),
              ),
            )
          ],
          if (Platform.isAndroid) ...[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  _navigatToSettingPage(context);
                },
                icon: Icon(Icons.settings),
              ),
            )
          ],
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.deepPurpleAccent,
              shape: StadiumBorder(),
              onPressed: () {
                AuthService().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ));
              },
              child: Text(
                'Log out',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

_navigatToSettingPage(context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingScreen(),
      ));
}
