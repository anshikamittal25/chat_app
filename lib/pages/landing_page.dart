import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/login_page.dart';
import 'package:instagram_clone/pages/home_page/my_home_page.dart';
import 'package:instagram_clone/services/shared_pref.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool isUserSignedIn;

  @override
  void initState() {
    prepare();
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
            if(isUserSignedIn==null){
              return LoginPage();
            }
            else if(isUserSignedIn){
              return MyHomePage();
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }


          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> prepare() async {
    bool t=await getBoolValuesSF();
    setState(() {
      isUserSignedIn = t;
    });
  }
}
