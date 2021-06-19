import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:instagram_clone/models/my_user.dart';
import 'package:instagram_clone/pages/message_screen/chat_room.dart';
import 'package:instagram_clone/services/my_db_class.dart';

class SearchTile extends StatelessWidget {
  final MyUser user;

  SearchTile({this.user});

  @override
  Widget build(BuildContext context) {
    bool isMe=(user.uid==FirebaseAuth.instance.currentUser.uid);
      return Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  user.username,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            FlatButton(
              textColor: Colors.white,
              color: (isMe)?Colors.grey[400]:Colors.pink[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Message'),
              onPressed: (){
                if(isMe){
                  return;
                }
                else {
                  MyDBClass.createChatRoom(user.uid);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => ChatRoom(user: user)));
                }
              },
            ),
          ],
        ),
      );
    }

  }
