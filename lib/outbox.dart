import 'package:catus/surveycard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catus/header.dart';
import 'package:catus/surveylist.dart';
import 'package:catus/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Outbox extends StatelessWidget {
  

  @override
  Widget build(BuildContext context){
    return StreamBuilder<User>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if(snapshot.hasData){
        User user = snapshot.data;
        if(user.isAnonymous == false) {
          return SurveyList(title: "Outbox", onlyOurs: false, authorMode: true, filter: (doc) {
            return (doc.data()['draft'] as bool);
          });
        } else {
          return Stack(
            children: [
              SafeArea(child: Header(showText: true, showProfile: false, text: "Inbox")),
              Center(child: promptLogin(context))
            ]
          );
        }
      } else {
        return Stack(
            children: [
              SafeArea(child: Header(showText: true, showProfile: false, text: "Inbox")),
              Center(child: promptLogin(context))
            ]
          );
      }
    });
  }

  Widget promptLogin(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          child: Image(image: AssetImage("assets/empty.png"), width: 300),
          padding: EdgeInsets.all(50.0)
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Text("You'll need an account to send surveys to your friends."),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          label: Text("Sign in or sign up"),
          onPressed: () => Navigator.push(context, createPopup(SignIn(goToProfile: false,)) )
        )
      ],
    );
  }
  
}