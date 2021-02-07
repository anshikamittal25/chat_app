import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAuthClass {
  static Future<String> registerEmail(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      /*User user = FirebaseAuth.instance.currentUser;

      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }*/
      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    }
    return null;
  }

  static Future<String> signInEmail(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      /*User user = FirebaseAuth.instance.currentUser;
      if (!user.emailVerified) {
        return 'unverified';
      }*/
      return 'success';
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return null;
  }

  static Future<String> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }
}
