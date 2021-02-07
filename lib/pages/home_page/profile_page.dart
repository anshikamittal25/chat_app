import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/login_page.dart';
import 'package:instagram_clone/services/my_auth_class.dart';
import 'package:instagram_clone/services/shared_pref.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'username',
          style: TextStyle(
              color: Colors.black, fontSize: 25,fontWeight: FontWeight.normal),
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

  signOut(BuildContext context) async {
    String s=await MyAuthClass.signOut();
    if(s=='success'){
      addBoolToSF(null);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }
    else{
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Some error occurred.'),
      ));
    }
  }
}
