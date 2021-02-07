import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/my_info.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/pages/message_screen/searches.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/tiles/chat_tile.dart';

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
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Chats',
          style: TextStyle(color: Colors.black),
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
                    String valUsername =
                        (arr[0] == MyInfo.myInfo['username']) ? arr[1] : arr[0];
                    return ChatTile(username:valUsername);
                  });
        },
      ),
    );
  }
}
