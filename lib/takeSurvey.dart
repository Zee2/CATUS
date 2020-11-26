import 'package:catus/header.dart';
import 'package:catus/editQuestionModal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:catus/signin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

typedef FutureCallback = Future<void> Function();

class TakeSurvey extends StatefulWidget {

  const TakeSurvey({Key key, this.index, this.survey, this.submitCallback}) : super(key: key);

  final String index;
  final FutureCallback submitCallback;

  // Key-value of survey data. Schemaless.. oh boy
  final QueryDocumentSnapshot survey;

  @override
  _TakeSurveyState createState() => _TakeSurveyState();
}

class _TakeSurveyState extends State<TakeSurvey> {

  Stream<QuerySnapshot> questions;
  Future<DocumentSnapshot> downloadedResponsesFuture;

  final _formKey = GlobalKey<FormState>(); // Key for validating survey responses

  @override
  void initState(){
    super.initState();
    questions = widget.survey.reference.collection('questions').orderBy('ordering').snapshots(includeMetadataChanges: true);
    downloadedResponsesFuture = widget.survey.reference.collection('responses').doc(FirebaseAuth.instance.currentUser.uid).get();
    
    if(FirebaseAuth.instance.currentUser != null) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        if(answersDirty) {
          print("Autosaving");
          widget.survey.reference.collection('responses').doc(FirebaseAuth.instance.currentUser.uid).set(answers, SetOptions(merge: true));
          answersDirty = false;
        }
        
      });
    }
    
  }
  
  Map<String, String> answers = new Map<String,String>();
  bool answersDirty = false;

  void processAnswer(String questionID, String answer){
    answers[questionID] = answer;
    answersDirty = true;
  }

  void processEdit(String questionID, String answer){
    answers[questionID] = answer;
    answersDirty = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: downloadedResponsesFuture,
      builder: (context, AsyncSnapshot<DocumentSnapshot> downloadedResponses) {

        if(!downloadedResponses.hasData || downloadedResponses.hasError){
          return Container();
        } else {
          return StreamBuilder<QuerySnapshot>(
            stream: questions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print("Snapshot waiting");
                return Text("Loading...");
              }
              print("Found " + snapshot.data.docs.length.toString() + "questions");

              return Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: List<Widget>.generate(snapshot.data.docs.length, (index) {
                      var question = snapshot.data.docs[index];
                      if (widget.survey.data()['draft']) {
                        return SurveyQuestion(question: question, updateCallback: processEdit, draft: true);
                      } else {
                        if(downloadedResponses.data.data() == null){
                          return SurveyQuestion(question: question, updateCallback: processAnswer, initial: null);
                        } else {
                          return SurveyQuestion(question: question, updateCallback: processAnswer, initial: downloadedResponses.data?.data()[question.id]);
                        }
                      }
                      //return TextQuestion(prompt: snapshot.data.docs[index]['prompt'],);
                    }) + (widget.survey.data()['draft'] as bool == true ? [
                      // add question button
                      Container(height: 20.0),
                      RaisedButton(
                        elevation: 10,
                        child: Container(
                          height: 50.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Add Question', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                            ]
                          )
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  ),
                        onPressed: () {
                          widget.survey.reference.update({'questionCount': snapshot.data.docs.length + 1});
                          widget.survey.reference.collection('questions').add({
                            'ordering': snapshot.data.docs.length + 1, // shush, lol
                            'type': 'text',
                            'prompt': 'Untitled Question'
                          });
                        },
                      )
                    ] : []) + [
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          elevation: 10,
                          child:  Container(
                            height: 50.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                    Text('Submit', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                                    Container(width: 10.0,),
                                    Icon(Icons.send, color: Colors.white,),
                            ]
                            )
                          ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    ),
                          onPressed: () {
                            print(answers);
                            widget.submitCallback().then((value) {
                              if(widget.survey.data()['draft']){
                                widget.survey.reference.set({'draft': false}, SetOptions(merge: true));
                                FirebaseFirestore.instance.collection('users').get().then((value) {
                                  List<String> users = [];
                                  for(var doc in value.docs){
                                    users.add(doc.id);
                                  }
                                  print("Adding recipients: " + users.toString());
                                  return widget.survey.reference.set({'recipients': users}, SetOptions(merge:true));
                                });
                              }
                            });
                          },

                        )
                      )
                    ]
                  )
                )
              );
            }
          );
        }
        
      }
    );
    
  }
}

class SurveyQuestion extends StatelessWidget {

  SurveyQuestion({Key key, this.question, this.updateCallback, this.draft = false, this.initial}) : super(key: key);

  final DocumentSnapshot question;
  final Function(String,String) updateCallback;
  final String initial;
  final bool draft;

  @override Widget build(BuildContext context) {
    Widget draw;
    switch(question['type']) {
      case 'rate': 
        draw = SliderQuestion(id: question.reference.id, prompt: question['prompt'], updateCallback: updateCallback, initial: initial);
        break;
      case 'text': 
        draw = TextQuestion(id: question.reference.id, prompt: question['prompt'], updateCallback: updateCallback,  initial: initial);
        break;
      default:
        draw = Container();
        break;
    }
    if (!draft) return draw;
    // in draft mode, tapping the widget pops up the edit description modal instead
    return GestureDetector(
      child: draw,
      onTap: () => Navigator.push(context, createPopup(EditQuestionModal(
        description: question['prompt'],
        type: question['type'],
        callbackSet: (description, type) {
          question.reference.update({"prompt": description, "type": type});
        }
      )))
    );
  }
}

class SliderQuestion extends StatefulWidget {
  
  SliderQuestion({Key key, this.prompt, this.updateCallback, this.id, this.initial}) : super(key: key);

  final String prompt;
  final String id;
  final String initial;
  final Function(String,String) updateCallback;

  @override
  _SliderQuestionState createState() => _SliderQuestionState();
}

class _SliderQuestionState extends State<SliderQuestion> {

  double _currentSliderValue;

  @override void initState(){
    super.initState();
    _currentSliderValue = double.parse(widget.initial ?? "1");
  }

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
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Slider(
              value: _currentSliderValue,
              min: 1,
              max: 5,
              divisions: 4,
              label: _currentSliderValue.round().toString(),
              onChanged: (value) => setState(() {
                _currentSliderValue = value;
                widget.updateCallback(widget.id, value.toString());
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
  
  TextQuestion({Key key, this.prompt, this.updateCallback, this.id, this.initial}) : super(key: key);

  final String prompt;
  final String id;
  final String initial;
  final Function(String,String) updateCallback;

  @override
  _TextQuestionState createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {

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
            child: TextFormField(
              maxLines: null,
              initialValue: widget.initial,
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
              onChanged: (value) {
                widget.updateCallback(widget.id, value.toString());
              },
            )
          )
        ],
      )
    );
  }
}