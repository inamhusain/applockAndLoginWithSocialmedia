// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'dart:io';

import 'package:fingerprint_auth_example/api/local_auth_api.dart';
import 'package:fingerprint_auth_example/helper/sharedpreference_halper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ValueNotifier<bool> isPin = ValueNotifier<bool>(false);
  ValueNotifier<bool> isBiometricEnable = ValueNotifier<bool>(false);
  ValueNotifier<bool> isDeviceSupportBiometrics = ValueNotifier<bool>(false);

  @override
  void initState() {
    setIsPinAvaible();
    checkhasBiometrics();
    setBioEnable();
    super.initState();
  }

  setIsPinAvaible() async {
    if (await SharedPreferenceHelper().getPassword() != '') {
      isPin.value = true;
    }
  }

  checkhasBiometrics() async {
    isDeviceSupportBiometrics.value = await LocalAuthApi.hasBiometrics();
  }

  setBioEnable() async {
    isBiometricEnable.value = await SharedPreferenceHelper().getBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            enablePin(),
            bioMetric(),
          ],
        ),
      ),
    );
  }

  bioMetric() {
    return ValueListenableBuilder(
      valueListenable: isDeviceSupportBiometrics,
      builder: (BuildContext context, dynamic value, Widget? child) {
        if (isDeviceSupportBiometrics.value) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable face | fingerprint Lock ',
                style: TextStyle(fontSize: 20),
              ),
              ValueListenableBuilder(
                valueListenable: isBiometricEnable,
                builder: (context, value, child) {
                  if (Platform.isIOS) {
                    return CupertinoSwitch(
                        activeColor: Colors.deepPurpleAccent,
                        value: isBiometricEnable.value,
                        onChanged: (value) {
                          _enableBioMetrics(value);
                        });
                  }
                  return Switch(
                      activeColor: Colors.deepPurpleAccent,
                      value: isBiometricEnable.value,
                      onChanged: (value) {
                        _enableBioMetrics(value);
                      });
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  _enableBioMetrics(value) async {
    if (value) {
      if (isPin.value == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please set PIN"),
        ));
      } else {
        final isAuthenticated = await LocalAuthApi.authenticate();
        print(isAuthenticated);
        if (isAuthenticated) {
          isBiometricEnable.value = value;
          await SharedPreferenceHelper().setBiometrics(true);
        }
      }
    } else {
      isBiometricEnable.value = value;
    }
  }

  enablePin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Enable PIN Lock',
          style: TextStyle(fontSize: 20),
        ),
        ValueListenableBuilder(
            valueListenable: isPin,
            builder: (context, value, child) {
              if (Platform.isIOS) {
                return CupertinoSwitch(
                    activeColor: Colors.deepPurpleAccent,
                    value: isPin.value,
                    onChanged: (value) {
                      _switchOnChange_pinLock(
                        value,
                        isPin: isPin,
                        context: context,
                      );
                    });
              }
              return Switch(
                  activeColor: Colors.deepPurpleAccent,
                  value: isPin.value,
                  onChanged: (value) {
                    _switchOnChange_pinLock(
                      value,
                      isPin: isPin,
                      context: context,
                    );
                  });
            }),
      ],
    );
  }

  _switchOnChange_pinLock(
    value, {
    required ValueNotifier<bool> isPin,
    context,
  }) async {
    if (value) {
      await _setPassword(context, value);
    } else {
      isPin.value = value;
      if (isDeviceSupportBiometrics.value) {
        isBiometricEnable.value = value;
        await SharedPreferenceHelper().removeBiometrics();
      }

      await SharedPreferenceHelper().removePassword();
    }
  }

  _setPassword(context, value) async {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Set Password'),
              actions: [
                MaterialButton(
                  child: Text('save', style: TextStyle(fontSize: 20)),
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
                      await SharedPreferenceHelper()
                          .setPassword(controller.text);
                      isPin.value = value;

                      Navigator.pop(context);
                    }
                  },
                )
              ],
              content: TextField(
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
            ));
  }
}
