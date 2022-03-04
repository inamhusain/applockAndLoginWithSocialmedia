import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferences? pref;

  static Future<SharedPreferences> getPrefObject() async {
    if (pref == null) pref = await SharedPreferences.getInstance();
    return pref!;
  }

  setPassword(String pass) async {
    await getPrefObject();
    await pref!.setString('pass', pass);
  }

  getPassword() async {
    await getPrefObject();

    String pass = pref!.getString('pass') ?? '';
    return pass;
  }

  removePassword() async {
    await getPrefObject();
    pref!.remove('pass');
  }

  setBiometrics(isBiometrics) async {
    await getPrefObject();
    await pref!.setBool('isBiometrics', isBiometrics);
  }

  getBiometrics() async {
    await getPrefObject();

    bool biometrics = pref!.getBool('isBiometrics') ?? false;
    return biometrics;
  }

  removeBiometrics() async {
    await getPrefObject();
    pref!.remove('isBiometrics');
  }
}
