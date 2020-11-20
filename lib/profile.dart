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
          Text("Profile Page!",
              style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -3.0)),
          ElevatedButton(
              clipBehavior: Clip.antiAlias,
              onPressed: () => {},
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(10.0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(CircleBorder()),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                enableFeedback: true,
              ),
              child: Image(
                // Doesn't work correctly; needs to redraw/set state on auth state change
                image: AssetImage("assets/person.png"),
                fit: BoxFit.cover,
                width: 200.0,
                height: 200.0,
              )),
          Text("Profile email: " + FirebaseAuth.instance.currentUser.email,
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -0.5)),
          // Text("Profile uid: " + FirebaseAuth.instance.currentUser.uid),
          RaisedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              color: Colors.red,
              child: Text("Sign out"))
        ],
      ),
    ));
  }
}
