import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/pages/landing_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SocioChat',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(color: Colors.white,elevation: 0,),
    ),
    home: LandingPage(),
  ));
}
