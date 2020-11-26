import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:catus/takeSurvey.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:number_to_words/number_to_words.dart';
import "stringextension.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catus/groups.dart';
import 'package:catus/surveycard.dart';
import 'package:catus/quickTeamFormation.dart';



class ResultCard extends StatefulWidget {

  ResultCard({Key key, this.data}) : super(key: key){
  }
  // Key-value of survey data. Schemaless.. oh boy
  final QueryDocumentSnapshot data;
  final List<LinearGradient> gradients = [FlutterGradients.mindCrawl(),
      FlutterGradients.solidStone(),
      FlutterGradients.eternalConstance(),
      FlutterGradients.mindCrawl(),];

  @override
  _ResultCardState createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> with TickerProviderStateMixin {

  bool isExpanded = false;
  bool isSent = false;

  LinearGradient gradient;

  AnimationController expandController;
  Animation<double> expandAnimation;

  AnimationController _sendController;
  Animation<Offset> _sendAnimation;
  Animation<double> _sendShrinkAnimation;

  @override
  void initState() {
    super.initState();

    gradient = widget.gradients[widget.data['title'].hashCode % widget.gradients.length];

    print("Initstate: " + widget.data.data()['title']);
    expandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0.0
    );

    expandAnimation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut
    );

    _sendController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      value: 0.0
    );

    _sendAnimation = Tween<Offset>(
      begin: const Offset(0.0,0.0),
      end: const Offset(1.5,0.0)
    ).animate(CurvedAnimation(
      parent: _sendController,
      curve: Curves.easeInBack,
    ));

    _sendShrinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0
    ).animate(CurvedAnimation(
      parent: _sendController,
      curve: Curves.easeInBack,
    ));
  }

  void tapCard(){

    isExpanded = !isExpanded;
    if(isExpanded)
      expandController.forward();
    else
      expandController.reverse();
    setState(() {});
  }

  sendCard(){
    isSent = true;
    _sendController.forward().then((value) => widget.data.reference.update({"completed": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid])}));
    // _sendController.forward();
    // Future.delayed(Duration(seconds: 5), () => widget.data.reference.update({"completed": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid])}));
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    expandController.dispose();
    _sendController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideTransition(
        position: _sendAnimation,
        child: AnimatedBuilder(
          animation: _sendShrinkAnimation,
          builder: (_, child) => Align(
              alignment: Alignment.center,
              heightFactor: _sendShrinkAnimation.value,
              widthFactor: null,
              child: child,
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
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
                GestureDetector(
                  onTap: () => tapCard(),
                  child: SurveyHero(widget.data, title: widget.data['title'], groups: widget.data['groups'].cast<String>(), gradient: gradient)
                ),
                
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
                  alignment: Alignment.topLeft,
                  child:Text(widget.data['description']),
                ),
                SizeTransition(
                  axis: Axis.vertical,
                  sizeFactor: expandAnimation,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                    alignment: Alignment.topLeft,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResultGrid(survey: widget.data)
                      ],
                    )
                  )
                )
              ],)
            )
        )
      )
    );
  }
}


class ResultGrid extends StatelessWidget {
  const ResultGrid({Key key, this.survey}) : super(key: key);

  final QueryDocumentSnapshot survey;
  
  @override
  Widget build(BuildContext context) {

    List<String> completed = survey['completed'].cast<String>();

    int myIndex = completed.indexOf(FirebaseAuth.instance.currentUser.uid);
    int teamSize = 4;

    return Center(
      child: Container(
        decoration: BoxDecoration(  
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(width: 2.0, color: Colors.black.withOpacity(0.1)),
              boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, offset: Offset(0,3))]
            ),
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text("YOUR TEAM", style: Theme.of(context).textTheme.bodyText1.copyWith(
                  letterSpacing: 2.0,
                  color: Colors.black.withOpacity(0.5)
                )),
            Container(height: 22.0),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 20.0,
              runSpacing: 10.0,
                children: List.generate(teamSize, (nameIndex){
                  try {
                    var uid = completed[(myIndex + nameIndex) % completed.length];
                    return DatabasePersonBubble(uid: uid);
                  } catch (re){
                    return Container();
                  }
                }
              )
            )
          ]
        )
      )
      
    );


  }
}