import 'package:catus/surveycard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catus/header.dart';

class SurveyList extends StatefulWidget {

  const SurveyList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> {


  @override
  Widget build(BuildContext context) {
    
    return ListView(
      
      physics: BouncingScrollPhysics(),
      children: [
        // A spacer.
        Header(showText: true, showProfile: false, text: widget.title),
        SurveyCard(),
        SurveyCard(),
        SurveyCard(),
        SurveyCard(),
        SurveyCard(),
        SurveyCard()
      ],
    );
  }
}
