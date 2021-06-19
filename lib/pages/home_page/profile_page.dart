import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:instagram_clone/models/my_user.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/pages/login_page.dart';
import 'package:instagram_clone/services/my_auth_class.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/services/shared_pref.dart';
import 'package:instagram_clone/tiles/post_tile.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: MyDBClass.getUserData(uid),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var user = snapshot.data;
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user['userPic']),
                    ),
                  ),
                  Text(
                    user['name'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(user['bio']),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width / 8,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.pink[900],
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                        user:
                                            MyUser.fromJson(user.data(), uid))))
                            .then((value) {
                          setState(() {});
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Container(
                      height: 1,
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future: MyDBClass.getPostsByFilter('uid', uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong!'));
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return (snapshot.data.docs.length == 0)
                            ? Center(
                                child: Text('No posts found!'),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(6),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  Post post = Post.fromJson(
                                      snapshot.data.docs[index].data(),
                                      snapshot.data.docs[index].id);
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showDialog(context, post);
                                      },
                                      child: Container(
                                        child:
                                            Image.network(post.urls[0]['file']),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data.docs.length,
                              );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _showDialog(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              scrollable: true,
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: PostTile(
                    post: post,
                  )),
            ));
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
