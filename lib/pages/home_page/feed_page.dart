import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/feed_posts.dart';
import 'package:instagram_clone/pages/message_screen/message_page.dart';
import 'package:instagram_clone/tiles/post_tile.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Instagram',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Pattaya', fontSize: 30),
        ),
        elevation: 0,
        leading: Icon(
          Icons.add_box_outlined,
          color: Colors.black,
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagePage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                Icons.message_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
              itemCount: feedPosts.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: PostTile(post: feedPosts[index]),
                );
              },
            ),
    );
  }
}
