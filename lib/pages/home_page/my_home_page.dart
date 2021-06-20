import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/home_page/profile_page.dart';
import 'package:instagram_clone/pages/home_page/category_page.dart';
import 'package:instagram_clone/pages/home_page/create_post_page.dart';
import 'package:instagram_clone/pages/home_page/feed_page.dart';
import 'package:instagram_clone/pages/home_page/category_post_page.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/services/shared_pref.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: chooseWidget(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.home,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.category_outlined,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.category_rounded,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.add_box_outlined,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.add_box,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.person_outline,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget chooseWidget() {
    switch (_currentIndex) {
      case 1:
        return CategoryPage();
      case 2:
        return CreatePostPage();
      /*case 3:
        return CategoryPostPage();*/
      case 3:
        return ProfilePage(fromHome:true,uid: FirebaseAuth.instance.currentUser.uid,);
      default:
        return FeedPage();
    }
  }
}
