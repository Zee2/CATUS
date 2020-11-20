import 'dart:html';

import 'package:catus/surveycard.dart';
import 'package:flutter/material.dart';
import 'package:catus/header.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SurveyList extends StatefulWidget {

  SurveyList({Key key, this.title, this.onlyOurs, this.authorMode = false, this.filter}) : super(key: key);

  final String title;
  final bool onlyOurs;
  final bool authorMode;
  final Function(DocumentSnapshot) filter;

  @override
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> with AutomaticKeepAliveClientMixin<SurveyList> {

  Stream<QuerySnapshot> surveys;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();

    if(widget.onlyOurs) {
      var user = FirebaseAuth.instance.currentUser;
      surveys = FirebaseFirestore.instance.collection("surveys").where('recipients', arrayContains: user.uid).snapshots();
    } else if(widget.authorMode) {
      var user = FirebaseAuth.instance.currentUser;
      surveys = FirebaseFirestore.instance.collection("surveys").where('author', isEqualTo: user.uid).snapshots();
    } else {
      surveys = FirebaseFirestore.instance.collection("surveys").snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    

    return StreamBuilder<QuerySnapshot>(
      stream: surveys,
      builder: (context, snapshot) {

        print("Streambuilder Test!");

        if (snapshot.hasError) {
          print("Snapshot error: " + snapshot.error.toString());
          return ListView(children: [Header(showText: true, showProfile: false, text: widget.title)] );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Snapshot waiting");
          return ListView(children: [Header(showText: true, showProfile: false, text: widget.title)] );
        }

        print("Found " + snapshot.data.docs.length.toString() + "documents");


        List<Widget> listElements = [Header(showText: true, showProfile: false, text: widget.title),];

        int counter = 0;
        for(DocumentSnapshot doc in snapshot.data.docs) {
          if(widget.filter == null || (widget.filter != null && widget.filter(doc))){
            listElements.add(SurveyCard(data: doc, index: counter));
            counter++;
          }
        }

        if(counter == 0) {
          listElements.add(Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: AssetImage("assets/empty.png"), width: 300.0,),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(widget.authorMode ? "You don't have any active campaigns at this time." : "Woohoo! No surveys.")
                )
                
              ],
            )
          ));
        }

        return ListView(
          physics: BouncingScrollPhysics(),
          children: listElements
        );


        // if(snapshot.data.docs.length == 0) {
        //   return ListView(
        //     children: [
        //       Header(showText: true, showProfile: false, text: widget.title),
              
              
        //     ]
        //   );
        // }

        // return ListView.builder(
        //   physics: BouncingScrollPhysics(),
        //   itemCount: snapshot.data.docs.length + 1,
        //   itemBuilder: (context, index) {
        //     if(index == 0)
        //       return Header(showText: true, showProfile: false, text: widget.title);
        //     else {
        //       var doc = snapshot.data.docs[index-1];
        //       if(widget.filter == null || (widget.filter != null && widget.filter(doc))){
        //         return SurveyCard(data: snapshot.data.docs[index-1], index: index - 1, isLast: index == snapshot.data.docs.length);
        //       }
                
        //     }
            
        //   }
        // );
      }
    );
  }
}
