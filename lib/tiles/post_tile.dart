import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';

class PostTile extends StatefulWidget {
  final Post post;
  PostTile({Key key,@required this.post}):super(key:key);
  @override
  _PostTileState createState() => _PostTileState(post: post);
}

class _PostTileState extends State<PostTile> {

  final Post post;
  _PostTileState({this.post});
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {

    String userName = post.userName;
    String userPic = post.userPic;
    List<String> images = post.images;
    int numLikes = post.numLikes;
    String caption = post.caption;
    int time = post.time;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(userPic),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Icon(Icons.more_vert),
            ],
          ),
        ),
        Image.asset(images[0]),
        Row(
          children: [
            IconButton(
              icon: Icon(
                (isLiked) ? Icons.favorite : Icons.favorite_border,
                color: (isLiked) ? Colors.red : Colors.black,
              ),
              onPressed: () {
                if(!isLiked){
                  post.numLikes++;
                }
                else{
                  post.numLikes--;
                }
                setState(() {
                  isLiked=!isLiked;
                });
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
            '$numLikes likes',
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
              Text(caption),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          child: Text(
            '$time days ago',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
