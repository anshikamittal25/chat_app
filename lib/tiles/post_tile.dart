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
  //List<Map<String, dynamic>> _controllers = [];
  //List<Map<String, dynamic>> _initializeVideoPlayerFutures = [];

  /*
  @override
  void initState() {
    var i = 0;
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
    });
    super.initState();
  }

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
    String userName = post.username;
    String userPic = post.userPic;
    List urls = post.urls;
    int likes = post.likes;
    String description = post.description;
    String time = post.time;
    String date = post.date;

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
                CircleAvatar(
                  backgroundImage: NetworkImage(userPic),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Icon(Icons.more_vert),
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
          Row(
            children: [
              IconButton(
                icon: Icon(
                  (isLiked) ? Icons.favorite : Icons.favorite_border,
                  color: (isLiked) ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    if (!isLiked) {
                      likes++;
                    } else {
                      likes--;
                    }
                    isLiked = !isLiked;
                  });

                  MyDBClass.updatePostData(post.id, {'likes': likes});
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.insert_comment_outlined,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send_outlined,
                  color: Colors.black,
                ),
              ),
              Spacer(
                flex: 1,
              ),
              IconButton(
                icon: Icon(
                  Icons.bookmark_border,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: Text(
              '$likes likes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '$userName ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: Text(
              '$date $time',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
