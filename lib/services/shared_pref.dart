import 'package:shared_preferences/shared_preferences.dart';

addBoolToSF(bool b) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isUserSignedIn', b);
}

getBoolValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isUserSignedIn = prefs.getBool('isUserSignedIn');
  return isUserSignedIn;
}