import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/feed_posts.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Instagram',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Pattaya', fontSize: 30),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(
          Icons.add_box_outlined,
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              Icons.message_outlined,
              color: Colors.black,
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
