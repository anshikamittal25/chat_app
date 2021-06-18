import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/pages/message_screen/message_page.dart';
import 'package:instagram_clone/services/my_db_class.dart';
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
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MessagePage()));
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
      body: FutureBuilder<QuerySnapshot>(
        future: MyDBClass.getPostsFeed(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return (snapshot.data.docs.length == 0)
                ? Center(
                  child: Text('No posts found!'),
                )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      Post post = Post.fromJson(snapshot.data.docs[index].data(),snapshot.data.docs[index].id);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: PostTile(post: post),
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
      /*(isLoading)?CircularProgressIndicator():ListView.builder(
              itemCount: feedPosts.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: PostTile(post: feedPosts[index]),
                );
              },
            ),*/
    );
  }

}
