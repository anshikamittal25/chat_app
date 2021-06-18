import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:instagram_clone/models/my_user.dart';
import 'package:instagram_clone/services/getChatRoomID.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/tiles/message_tile.dart';
import 'package:instagram_clone/tiles/shoutout_message_tile.dart';

class ShoutOutChatRoom extends StatefulWidget {
  final String category;

  ShoutOutChatRoom({Key key, this.category}) : super(key: key);

  @override
  _ShoutOutChatRoomState createState() => _ShoutOutChatRoomState();
}

class _ShoutOutChatRoomState extends State<ShoutOutChatRoom> {
  TextEditingController _text = TextEditingController();
  Stream msgStream;

  @override
  void initState() {
    setState(() {
      msgStream = MyDBClass.getShoutOut(widget.category);
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
        title: Text(
          widget.category,
          style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold, color: Colors.black),
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
                              return ShoutOutMessageTile(
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
      MyDBClass.addShoutOut(_text.text, widget.category);
      _text.text = '';
    }
  }
}
