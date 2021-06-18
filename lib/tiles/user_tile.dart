import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/my_user.dart';
import 'package:instagram_clone/pages/message_screen/chat_room.dart';
import 'package:instagram_clone/services/my_db_class.dart';

class UserTile extends StatefulWidget {
  final String uid;

  UserTile({this.uid});

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  MyUser user;

  @override
  void initState() {
    MyDBClass.getUserData(widget.uid).then((value) {
      setState(() {
        user = MyUser.fromJson(value.data(), widget.uid);
      });
    }).catchError((e) => print(e));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoom(
                      user: user,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: (user == null)
            ? Container()
            : Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.userPic),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
      ),
    );
  }
}
