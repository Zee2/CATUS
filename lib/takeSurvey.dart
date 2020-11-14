import 'package:catus/header.dart';
import 'package:catus/surveycard.dart';
import 'package:flutter/material.dart';

class TakeSurvey extends StatefulWidget {

  const TakeSurvey({Key key, this.index}) : super(key: key);

  final String index;

  @override
  _TakeSurveyState createState() => _TakeSurveyState();
}

class _TakeSurveyState extends State<TakeSurvey> {

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Column(
        children: [
          SliderQuestion(),
          SliderQuestion(),
          SliderQuestion(),
          SliderQuestion(),
          
        ],
      ),
    );
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
              onChanged: (value) => setState(() => _currentSliderValue = value),
            )
          )
        ],
      )
    );
  }
}