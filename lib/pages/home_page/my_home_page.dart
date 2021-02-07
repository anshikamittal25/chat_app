import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/profile_page.dart';
import 'package:instagram_clone/pages/search_page.dart';
import 'package:instagram_clone/pages/create_post_page.dart';
import 'package:instagram_clone/pages/feed_page.dart';
import 'package:instagram_clone/pages/notif_page.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
