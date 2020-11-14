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

class _SurveyListState extends State<SurveyList> with AutomaticKeepAliveClientMixin<SurveyList> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      
      physics: BouncingScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) {
        if(index == 0)
          return Header(showText: true, showProfile: false, text: widget.title);
        else
          return SurveyCard(index: index - 1,);
      }
    );
  }
}
