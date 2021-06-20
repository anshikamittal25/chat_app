import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:instagram_clone/pages/home_page/profile_page.dart';
import 'package:instagram_clone/services/my_db_class.dart';

// ignore: must_be_immutable
class ShoutOutMessageTile extends StatelessWidget {
  final Map<String, dynamic> map;

  ShoutOutMessageTile({this.map});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: MyDBClass.getUserData(map['uid']),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var user = snapshot.data;
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 90, 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.purple,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                uid: snapshot.data.id,
                                fromHome:false,
                              )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user['userPic']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            user['username'],
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 5),
                    child: Text(
                      map['message'],
                      //overflow: TextOverflow.visible,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          map['date'],
                          //overflow: TextOverflow.visible,
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                        Text(
                          map['time'],
                          //overflow: TextOverflow.visible,
                          textAlign: TextAlign.end,
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
