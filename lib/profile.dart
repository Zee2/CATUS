

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile Page!"),
            Text("Profile email: " + FirebaseAuth.instance.currentUser.email),
            Text("Profile uid: " + FirebaseAuth.instance.currentUser.uid),
            RaisedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              color: Colors.red,
              child: Text("Sign out")
            )
          ],
        )
      )
    );
  }
}