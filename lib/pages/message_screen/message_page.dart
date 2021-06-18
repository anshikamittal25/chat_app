import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:instagram_clone/pages/message_screen/searches.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/tiles/user_tile.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Stream chatRoomStream;

  @override
  void initState() {
    setState(() {
      chatRoomStream = MyDBClass.getChatRooms();
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
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Chats',
          style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Searches()));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return (!snapshot.hasData)
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var arr =
                        snapshot.data.docs[index].data()['users'];
                    String uid =
                        (arr[0] == FirebaseAuth.instance.currentUser.uid) ? arr[1] : arr[0];
                    return UserTile(uid: uid);
                  });
        },
      ),
    );
  }
}
