import 'package:catus/header.dart';
import 'package:catus/surveycard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TakeSurvey extends StatefulWidget {

  const TakeSurvey({Key key, this.index, this.survey}) : super(key: key);

  final String index;

  // Key-value of survey data. Schemaless.. oh boy
  final QueryDocumentSnapshot survey;


  @override
  _TakeSurveyState createState() => _TakeSurveyState();
}

class _TakeSurveyState extends State<TakeSurvey> {

  Stream<QuerySnapshot> questions;

  @override
  void initState(){
    super.initState();
    questions = widget.survey.reference.collection('questions').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<QuerySnapshot>(
      stream: questions,
      builder: (context, snapshot) {
        print("Found " + snapshot.data.docs.length.toString() + "questions");
        return Container(
          child: Column(
            children: List.generate(snapshot.data.docs.length, (index) {
              
              //return TextQuestion(prompt: snapshot.data.docs[index]['prompt'],);
            })
          )
        );
      }

      
    );
  }
}


class SurveyQuestion extends StatelessWidget {

  const SurveyQuestion({Key key, this.questionType, this.prompt}) : super(key: key);

  final String questionType;
  final String prompt;

  @override Widget build(BuildContext context) {
    switch(questionType) {
      case 'rate': 
        return SliderQuestion(prompt: snapshot.data.docs[index]['prompt']);
    }
  }
}

class SliderQuestion extends StatefulWidget {
  
  @override
  _SliderQuestionState createState() => _SliderQuestionState();
}

class _SliderQuestionState extends State<SliderQuestion> {

  double _currentSliderValue = 1;

  @override Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 10, offset: Offset(0,3))]
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This is a question that is answered by a 1-5 slider. This will eventually be pulled from a Firebase NoSQL database."),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Slider(
              value: _currentSliderValue,
              min: 1,
              max: 5,
              divisions: 4,
              label: _currentSliderValue.round().toString(),
              onChanged: (value) => setState(() {
                _currentSliderValue = value;
                HapticFeedback.selectionClick();
              }),
            )
          )
        ],
      )
    );
  }
}

class TextQuestion extends StatefulWidget {
  
  const TextQuestion({Key key, this.prompt}) : super(key: key);

  final String prompt;

  @override
  _TextQuestionState createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {

  double _currentSliderValue = 1;

  @override Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 10, offset: Offset(0,3))]
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.prompt),
          Container(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                labelText: "Type your answer..."
              ),
              onTap: () {
                final snack = SnackBar(content: Text("Catus auto-saves your answers!"), duration: Duration(seconds: 1));
                Scaffold.of(context).showSnackBar(snack);
              },
            )
          )
        ],
      )
    );
  }
}