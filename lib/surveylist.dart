import 'package:catus/surveycard.dart';
import 'package:flutter/material.dart';
import 'package:catus/header.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyList extends StatefulWidget {

  SurveyList({Key key, this.title}) : super(key: key);

  final String title;
  

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
    surveys = FirebaseFirestore.instance.collection("surveys").snapshots();
  }

  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    

    return StreamBuilder<QuerySnapshot>(
      stream: surveys,
      builder: (context, snapshot) {

        print("Test!");

        if (snapshot.hasError) {
          return ListView(children: [Header(showText: true, showProfile: false, text: widget.title)] );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView(children: [Header(showText: true, showProfile: false, text: widget.title)] );
        }

        print("Found " + snapshot.data.docs.length.toString() + "documents");

        if(snapshot.data.docs.length == 0) {
          return ListView(
            children: [
              Header(showText: true, showProfile: false, text: widget.title),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(image: AssetImage("assets/empty.png"), width: 300.0,),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Text("No surveys yet. Try making some!")
                    )
                    
                  ],
                )
              )
              
            ]
          );
        }

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data.docs.length + 1,
          itemBuilder: (context, index) {
            if(index == 0)
              return Header(showText: true, showProfile: false, text: widget.title);
            else
              return SurveyCard(data: snapshot.data.docs[index-1].data(), index: index - 1,);
          }
        );
      }
    );
  }
}
