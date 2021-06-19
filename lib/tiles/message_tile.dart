import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/data/data.dart';

// ignore: must_be_immutable
class MessageTile extends StatelessWidget {
  final Map<String, dynamic> map;
  bool byMe;

  MessageTile({this.map});

  @override
  Widget build(BuildContext context) {
    byMe = (map['sendBy'] == FirebaseAuth.instance.currentUser.uid);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          if(byMe)Spacer(),
          Flexible(
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
                  color: byMe ? Colors.purple : Colors.black87),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    map['message'],
                    //overflow: TextOverflow.visible,
                    textAlign: byMe?TextAlign.end:TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          map['date'],
                          //overflow: TextOverflow.visible,
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                        Text(
                          map['time'],
                          //overflow: TextOverflow.visible,
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(!byMe) Spacer(),
        ],
      ),
    );
  }
}
