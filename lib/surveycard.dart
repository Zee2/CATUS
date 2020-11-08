import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SurveyCard extends StatefulWidget {
  @override
  _SurveyCardState createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 20.0, right: 20.0),
        constraints: BoxConstraints(maxWidth: 400.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, offset: Offset(0,3))]
        ),
        child: Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/forest.jpg"), fit: BoxFit.cover)
                ),
                child: Text(
                  "Team Formation",
                  style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Colors.white)),
                )
              )
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Initial survey to ensure teams are chosen fairly. Lorem ipsum dolor the quick brown fox",
                textAlign: TextAlign.start,
              )
            )
          ],)
        )
    );
  }
}
