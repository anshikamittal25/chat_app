import 'package:shared_preferences/shared_preferences.dart';

addBoolToSF(String s,bool b) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(s, b);
}

getBoolValuesSF(String s) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isUserSignedIn = prefs.getBool(s);
  return isUserSignedIn;
}