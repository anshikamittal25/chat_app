import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/my_user.dart';
import 'package:intl/intl.dart';
import 'getChatRoomID.dart';

class MyDBClass {
  static addUserInfo(String userName, String name, String bio, String image) {
    if (image == null || image == '') {
      image =
          'https://firebasestorage.googleapis.com/v0/b/instagramclone-6b349.appspot.com/o/users%2Fimage_cropper_1622215258288.png%7D?alt=media&token=9ea63455-5ebc-4f24-9cf2-f5eae04434f9';
    }
    final User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'email': user.email,
          'username': userName,
          'name': name,
          'bio': bio ?? '',
          'userPic': image,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future getUserData(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  static Future getUserByUsername(String userName) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: userName)
        .get();
  }

  static addPosts(
      List<Map<String, String>> posts, String des, String category) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('kk:mm').format(now);
    String formattedDate = DateFormat('EEE d MMM').format(now);
    final User user = FirebaseAuth.instance.currentUser;
    getUserData(user.uid)
        .then((value) => FirebaseFirestore.instance
            .collection('posts')
            .add({
              'uid': user.uid,
              'username': value.data()['username'],
              'userPic': value.data()['userPic'],
              'urls': posts,
              'description': des,
              'timeStamp': now.millisecondsSinceEpoch,
              'time': formattedTime,
              'date': formattedDate,
              'likes': 0,
              'category': category.toLowerCase()
            })
            .then((value) => print("Post Added"))
            .catchError((error) => print("Failed to add post: $error")))
        .catchError((error) => print("Failed to add post: $error"));
  }

  static getPostsFeed() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timeStamp', descending: true)
        .get();
  }

  //by uid or category
  static getPostsByFilter(String type, value) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where(type, isEqualTo: value)
        .orderBy('timeStamp', descending: true)
        .get();
  }

  static updatePostData(String id, Map<String, dynamic> data) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .set(data)
        .then((value) => print("Post updated"))
        .catchError((error) => print("Failed to update post: $error"));
  }

  static createChatRoom(String uid) {
    String me = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(getChatRoomID(uid, me))
        .set({
          'users': [uid, me],
        })
        .then((value) => print("Chat room added"))
        .catchError((error) => print("Failed to add chat room: $error"));
  }

  static addChats(String msg, String uid) {
    String me = FirebaseAuth.instance.currentUser.uid;
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('kk:mm').format(now);
    String formattedDate = DateFormat('EEE d MMM').format(now);
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(getChatRoomID(uid, me))
        .collection('chats')
        .add({
          'message': msg,
          'sendBy': me,
          'time': formattedTime,
          'date': formattedDate,
          'timeStamp': now.millisecondsSinceEpoch,
        })
        .then((value) => print("Msg sent"))
        .catchError((error) => print("Failed to send msg: $error"));
  }

  static getMessages(String uid) {
    String me = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(getChatRoomID(uid, me))
        .collection('chats')
        .orderBy('timeStamp')
        .snapshots();
  }

  static getShoutOut(String category) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(category)
        .collection('chats')
        .orderBy('timeStamp')
        .snapshots();
  }

  static addShoutOut(String msg, String category) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('kk:mm').format(now);
    String formattedDate = DateFormat('EEE d MMM').format(now);
    final User user = FirebaseAuth.instance.currentUser;
    getUserData(user.uid).then((value) => FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(category)
        .collection('chats')
        .add({
          'message': msg,
          'uid': user.uid,
          'username': value.data()['username'],
          'userPic': value.data()['userPic'],
          'time': formattedTime,
          'date': formattedDate,
          'timeStamp': now.millisecondsSinceEpoch,
        })
        .then((value) => print("Msg sent"))
        .catchError((error) => print("Failed to send msg: $error"))
        .catchError((error) => print("Failed to send msg: $error")));
  }

  static getChatRooms() {
    String me = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users', arrayContains: me)
        .snapshots();
  }
}
