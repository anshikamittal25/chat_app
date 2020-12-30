import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  final String email;

  VerifyEmail({Key key,@required this.email}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex:10),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text('VERIFY EMAIL',style: TextStyle(fontSize: 20),),
                ),
                Text(
                  'Verify your email address by clicking on the link we sent to: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${widget.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.blue[700]),
                ),
                Spacer(flex:1),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('Resend mail',style: TextStyle(color: Colors.white,),),
                    onPressed: () async {
                      User user = FirebaseAuth.instance.currentUser;
                        print(user);
                      if (!user.emailVerified) {
                        await user.sendEmailVerification();
                      }
                    },
                  ),
                ),
                Spacer(flex:10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
