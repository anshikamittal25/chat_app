import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:video_player/video_player.dart';

class PostTile extends StatefulWidget {
  final Post post;

  PostTile({Key key, @required this.post}) : super(key: key);

  @override
  _PostTileState createState() => _PostTileState(post: post);
}

class _PostTileState extends State<PostTile> {
  final Post post;
  _PostTileState({this.post});
  bool isLiked = false;
  String username;
  String userPic;
  String uid;
  List urls;
  String description;
  String time;
  String date;
  List<dynamic> whoLiked;
  //List<Map<String, dynamic>> _controllers = [];
  //List<Map<String, dynamic>> _initializeVideoPlayerFutures = [];

  @override
  void initState() {
    /*var i = 0;
    post.urls.forEach((url) {
      if (url['type'] == 'video') {
        _controllers.add({
          'index': i,
          'value': VideoPlayerController.network(
            url['file'],
          )
        });
        _initializeVideoPlayerFutures.add(
            {'index': i, 'value': _controllers.last['value'].initialize()});
      }
      i++;
    });*/
    uid = post.uid;
    urls = post.urls;
    description = post.description;
    time = post.time;
    date = post.date;
    whoLiked = post.whoLiked;

    setState(() {
      isLiked = whoLiked.contains(FirebaseAuth.instance.currentUser.uid);
    });

    _userInfo();

    super.initState();
  }

  _userInfo() async {
    var user = await MyDBClass.getUserData(post.uid);
    setState(() {
      userPic = user['userPic'];
      username = user['username'];
    });
  }
/*
  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controllers.forEach((element) {
      element['value'].dispose();
    });

    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (userPic != null)
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(userPic),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    username ?? ' ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Text(
                  '$date $time',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width / 1.5,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: urls.length,
                itemBuilder: (context, index) {
                  return (urls[index]['type'] == 'image')
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(urls[index]['file']))
                      : Container(
/*width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                // If the video is playing, pause it.
                                if (_controllers
                                    .firstWhere((element) =>
                                        element['index'] == index)['value']
                                    .value
                                    .isPlaying) {
                                  _controllers
                                      .firstWhere((element) =>
                                          element['index'] == index)['value']
                                      .pause();
                                } else {
                                  // If the video is paused, play it.
                                  _controllers
                                      .firstWhere((element) =>
                                          element['index'] == index)['value']
                                      .play();
                                }
                              });
                            },
                            child: FutureBuilder(
                              future: _initializeVideoPlayerFutures.firstWhere(
                                  (element) =>
                                      element['index'] == index)['value'],
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return AspectRatio(
                                    aspectRatio: _controllers
                                        .firstWhere((element) =>
                                            element['index'] == index)['value']
                                        .value
                                        .aspectRatio,
                                    child: VideoPlayer(_controllers.firstWhere(
                                        (element) =>
                                            element['index'] == index)['value']),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),*/
                          );
                }),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 14),
            child: Text(description,style: TextStyle(color: Colors.black, fontSize: 15),),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:30.0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  if (!isLiked) {
                    post.likes++;
                    post.whoLiked.add(FirebaseAuth.instance.currentUser.uid);
                    MyDBClass.updatePostData(post.id,
                        {'likes': post.likes, 'whoLiked': post.whoLiked});
                  } else {
                    post.likes--;
                    post.whoLiked
                        .remove(FirebaseAuth.instance.currentUser.uid);
                    MyDBClass.updatePostData(post.id,
                        {'likes': post.likes, 'whoLiked': post.whoLiked});
                  }
                  isLiked = !isLiked;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      (isLiked) ? Icons.favorite : Icons.favorite_border,
                      color: (isLiked) ? Colors.red : Colors.black,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      '${post.likes} likes',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
