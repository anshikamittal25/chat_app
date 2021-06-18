import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/pages/home_page/shoutout_chatroom.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/tiles/post_tile.dart';

class CategoryPostPage extends StatefulWidget {
  final String category;

  CategoryPostPage({Key key, this.category}) : super(key: key);

  @override
  _CategoryPostPageState createState() => _CategoryPostPageState();
}

class _CategoryPostPageState extends State<CategoryPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.category,
          style: TextStyle(
              color: Colors.black, fontFamily: 'Pattaya', fontSize: 30),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[900],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset('assets/icons/megaphone.svg',color: Colors.white,),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShoutOutChatRoom(
                        category: widget.category,
                      )));
        },
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: MyDBClass.getPostsByFilter(
            'category', widget.category.toLowerCase()),
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
                : GridView.builder(
                    padding: const EdgeInsets.all(6),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            child: Image.network(post.urls[0]['file']),
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
}
