import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/my_info.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/getChatRoomID.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/tiles/message_tile.dart';

class ChatRoom extends StatefulWidget {
  final MyUser user;

  ChatRoom({Key key, this.user}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String me = MyInfo.myInfo['username'];
  TextEditingController _text = TextEditingController();
  Stream msgStream;

  @override
  void initState() {
    setState(() {
      msgStream = MyDBClass.getMessages(widget.user.userName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 15,
              child: Text(
                widget.user.userName.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.white,),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.user.userName,
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            StreamBuilder(
              stream: msgStream,
              builder: (context, snapshot) {
                return (!snapshot.hasData)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return MessageTile(
                                  map: snapshot.data.docs[index].data());
                            }),
                      );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _text,
                        cursorColor: Colors.black,
                        //cursorHeight: 30,
                        decoration: InputDecoration(
                          hintText: 'Enter message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    if (_text.text != '') {
      MyDBClass.addChats(_text.text, widget.user.userName);
      _text.text = '';
    }
  }
}
