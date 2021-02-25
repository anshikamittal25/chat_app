import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/home_page/profile_page.dart';
import 'package:instagram_clone/pages/home_page/search_page.dart';
import 'package:instagram_clone/pages/home_page/create_post_page.dart';
import 'package:instagram_clone/pages/home_page/feed_page.dart';
import 'package:instagram_clone/pages/home_page/notif_page.dart';
import 'package:instagram_clone/data/my_info.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex=0;
  String uid = FirebaseAuth.instance.currentUser.uid;
  DocumentSnapshot doc;
  bool isLoading;

  @override
  void initState() {
    isLoading=true;
    prepare();
    super.initState();
  }

  void prepare() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      doc = value;
    }).catchError((e) {
      print(e);
    });
    print(doc.data().toString());
    MyInfo.myInfo=doc.data();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
      backgroundColor: Colors.white,
      body: chooseWidget(),
      /*bottomNavigationBar: TabBar(
        tabs: [
          Tab(icon: Icon(Icons.home_outlined,size: 30,),),
          Tab(icon: Icon(Icons.search,size: 30,),),
          Tab(icon: Icon(Icons.add_box_outlined,size: 30,),),
          Tab(icon: Icon(Icons.favorite_border,size: 30,),),
          Tab(icon: CircleAvatar(backgroundImage: AssetImage('assets/images/profile.jpeg'),radius: 18,),),
        ],
        labelPadding: EdgeInsets.all(15),

        unselectedLabelColor: Colors.black,
        unselectedLabelStyle: TextStyle(fontSize: 40),
        labelColor: Colors.black,
        labelStyle: TextStyle(fontSize: 100,fontWeight: FontWeight.w900),
      ),*/
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (i){
          setState(() {
            _currentIndex=i;
          });
        },
        items: [
          BottomNavigationBarItem(label:'',icon: Icon(Icons.home_outlined,size: 30,),activeIcon: Icon(Icons.home,size: 30,),),
          BottomNavigationBarItem(label:'',icon: Icon(Icons.search,size: 30,),activeIcon: Icon(Icons.search,size: 30,),),
          BottomNavigationBarItem(label:'',icon: Icon(Icons.add_box_outlined,size: 30,),activeIcon: Icon(Icons.add_box,size: 30,),),
          BottomNavigationBarItem(label:'',icon: Icon(Icons.favorite_border,size: 30,),activeIcon: Icon(Icons.favorite,size: 30,),),
          BottomNavigationBarItem(label:'',icon: CircleAvatar(backgroundImage: AssetImage('assets/images/profile.jpeg'),radius: 18,),),
        ],
      ),
    );
  }

  Widget chooseWidget() {
    switch(_currentIndex){
      case 1:
        return SearchPage();
      case 2:
        return CreatePostPage();
      case 3:
        return NotifPage();
      case 4:
        return ProfilePage();
      default:
        return FeedPage();
    }
  }
}
