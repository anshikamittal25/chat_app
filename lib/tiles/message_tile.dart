import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/data/my_info.dart';

class MessageTile extends StatelessWidget {
  final Map<String, dynamic> map;
  MessageTile({this.map});
  bool byMe;

  @override
  Widget build(BuildContext context) {
    byMe = (map['sendby'] == MyInfo.myInfo['username']);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        alignment: byMe ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: byMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
            color: byMe ? Colors.blue[800] : Colors.pink),
        padding: EdgeInsets.all(10),
        child: Text(
          map['message'],
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
