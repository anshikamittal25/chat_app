import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/pages/message_screen/chat_room.dart';
import 'package:instagram_clone/services/my_db_class.dart';

class ChatTile extends StatelessWidget {
  final String username;

  ChatTile({this.username});

  @override
  Widget build(BuildContext context) {
    String email;
    MyDBClass.getUserByUsername(username).then((value) { email=value.data.docs[0]['email'];}).catchError((e)=>print(e));
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRoom(user: MyUser(userName: username,email: email),)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(username.substring(0,1).toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 30),),
            ),
            SizedBox(width: 20,),
            Text(username,style: TextStyle(fontSize: 30),),
          ],
        ),
      ),
    );
  }
}
