import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/data/my_info.dart';

import 'getChatRoomID.dart';

class MyDBClass {

  static addUserInfo(String uid, String email, String userName) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          'username': userName,
          'email': email,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future getUserByUsername(String userName) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: userName)
        .get();
  }

  static createChatRoom(String username){
    String me=MyInfo.myInfo['username'];
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(getChatRoomID(username,me))
        .set({
      'users': [username,me],
    })
        .then((value) => print("Chat room added"))
        .catchError((error) => print("Failed to add chat room: $error"));
  }

  static addChats(String msg,String username) {
    String me=MyInfo.myInfo['username'];
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(getChatRoomID(username,me))
    .collection('chats')
        .add({
      'message': msg,
      'sendby': me,
      'time': DateTime.now().millisecondsSinceEpoch,
    }).then((value) => print("Msg sent"))
        .catchError((error) => print("Failed to send msg: $error"));
  }
  static getMessages(String userName){
    String me=MyInfo.myInfo['username'];
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(getChatRoomID(userName,me))
        .collection('chats').orderBy('time').snapshots();
  }
  static getChatRooms(){
    String me=MyInfo.myInfo['username'];
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users',arrayContains: me).snapshots();
  }

}
