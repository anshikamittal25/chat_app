import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:instagram_clone/pages/login_page.dart';
import 'package:instagram_clone/services/my_auth_class.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/services/shared_pref.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: MyDBClass.getUserData(FirebaseAuth.instance.currentUser.uid),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var user=snapshot.data;
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                user['username'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.normal),
              ),
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: () {
                    signOut(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  signOut(BuildContext context) async {
    String s = await MyAuthClass.signOut();
    if (s == 'success') {
      //addBoolToSF('isUserSignedIn', false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Some error occurred.'),
      ));
    }
  }
}
