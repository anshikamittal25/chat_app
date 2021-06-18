import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/home_page/category_page.dart';
import 'package:instagram_clone/pages/home_page/create_post_page.dart';
import 'package:instagram_clone/pages/home_page/feed_page.dart';
import 'package:instagram_clone/pages/login_page.dart';
import 'package:instagram_clone/pages/home_page/my_home_page.dart';
import 'package:instagram_clone/services/shared_pref.dart';

import '../services/my_db_class.dart';
import '../services/shared_pref.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Image.asset('assets/images/error.png'),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (FirebaseAuth.instance.currentUser==null) {
              return LoginPage();
            } else {
              return MyHomePage();
            }

            //return CreatePostPage();
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
