import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/my_info.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/pages/message_screen/chat_room.dart';
import 'package:instagram_clone/services/my_db_class.dart';

class SearchTile extends StatelessWidget {
  final MyUser user;

  SearchTile({this.user});

  @override
  Widget build(BuildContext context) {
    bool isMe=(user.userName==MyInfo.myInfo['username']);
      return Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  user.userName,
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
              color: (isMe)?Colors.grey[400]:Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Message'),
              onPressed: (){
                if(isMe){
                  return;
                }
                else {
                  MyDBClass.createChatRoom(user.userName);
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
