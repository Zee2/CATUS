import 'package:flutter/material.dart';
import 'package:catus/takeSurvey.dart';
import 'package:flutter/services.dart';

class SurveyCard extends StatefulWidget {

  @override
  _SurveyCardState createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> with SingleTickerProviderStateMixin {

  bool isExpanded = false;

  AnimationController expandController;
  Animation<double> expandAnimation;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      value: 0.0
    );

    expandAnimation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => setState(() {
          isExpanded = !isExpanded;
          if(isExpanded)
            expandController.forward();
          else
            expandController.reverse();
        }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin:
            isExpanded ?
              EdgeInsets.only(bottom: 10.0, top: 10.0, left: 0.0, right: 0.0) 
                : EdgeInsets.only(bottom: 10.0, top: 10.0, left: 20.0, right: 20.0),
          constraints: BoxConstraints(maxWidth: 800.0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, offset: Offset(0,3))]
          ),
          child: Column(children: [
              SurveyHero(),
              Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.topLeft,
                child:Text("Survey description, blah blah blah.."),
                
              ),
              SizeTransition(
                axis: Axis.vertical,
                sizeFactor: expandAnimation,
                child: Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.topLeft,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TakeSurvey()
                  ],
                )
                
              )
              )
                    
            ],)
          )
      )
      
    );
  }
}

class SurveyHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/forest.jpg"), fit: BoxFit.cover)
      ),
      child: Text(
        "Team Formation",
        style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Colors.white)),
      )
    );
  }
}
