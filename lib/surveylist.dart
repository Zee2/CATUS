import 'package:catus/surveycard.dart';
import 'package:flutter/material.dart';
import 'package:catus/header.dart';
import 'package:catus/resultcard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SurveyList extends StatefulWidget {

  SurveyList({Key key, this.title, this.onlyOurs, this.authorMode = false, this.resultMode = false, this.filter}) : super(key: key);

  final String title;
  final bool onlyOurs;
  final bool authorMode;
  final bool resultMode;
  final Function(DocumentSnapshot) filter;

  @override
  _SurveyListState createState() => _SurveyListState();
}

// class _SurveyListState extends State<SurveyList> with AutomaticKeepAliveClientMixin<SurveyList> {
class _SurveyListState extends State<SurveyList>{

  Stream<QuerySnapshot> surveys;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();

    if(widget.resultMode) {
      assert(widget.onlyOurs);
      assert(!widget.authorMode);
    }

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
            listElements.add(widget.resultMode ? ResultCard(key: Key(doc.reference.id), data:doc) : SurveyCard(key: Key(doc.reference.id), data: doc, authorMode: widget.authorMode,));
            counter++;
          } else {
            print("Filtering a doc");
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
                  child: Text(widget.authorMode ? "You don't have any active campaigns at this time." : widget.resultMode ? "You don't have any results. Try making a survey!" : "Woohoo! No surveys.")
                )
                
              ],
            )
          ));
        }

        return ListView(
          physics: BouncingScrollPhysics(),
          children: listElements
        );
      }
    );
  }
}
