import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:catus/takeSurvey.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:number_to_words/number_to_words.dart';
import "stringextension.dart";
import 'package:catus/groups.dart';



class SurveyCard extends StatefulWidget {

  SurveyCard({Key key, this.index, this.data, this.isLast}) : super(key: key){
    List<LinearGradient> gradients = [
      FlutterGradients.mindCrawl(),
      FlutterGradients.solidStone(),
      FlutterGradients.blackSea(),
      FlutterGradients.spaceShift(),
    ];
    gradient = gradients[index % gradients.length];
  }

  final index;
  final bool isLast;
  // Key-value of survey data. Schemaless.. oh boy
  final QueryDocumentSnapshot data;
  LinearGradient gradient;

  @override
  _SurveyCardState createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> with TickerProviderStateMixin {

  bool isExpanded = false;
  bool isSent = false;

  AnimationController expandController;
  Animation<double> expandAnimation;

  AnimationController _sendController;
  Animation<Offset> _sendAnimation;
  Animation<double> _sendShrinkAnimation;

  @override
  void initState() {
    super.initState();
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
    _sendController.forward();
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
                  : EdgeInsets.only(bottom: widget.isLast ? 40.0 : 10.0, top: 10.0, left: 20.0, right: 20.0),
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
                  child: SurveyHero(title: widget.data['title'], groups: widget.data['groups'].cast<String>(), gradient: widget.gradient)
                ),
                
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                  alignment: Alignment.topLeft,
                  child:Text(widget.data['description']),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(Icons.thumbs_up_down_outlined, size: 20.0, color: Colors.grey,),
                      Container(width: 10),
                      Text(widget.data['questionCount'].toString() + " questions", style: TextStyle(color: Colors.grey))
                    ]
                  )
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, bottom: 20.0, top: 5.0, right: 20.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(Icons.access_time_outlined, size: 20.0, color: Colors.grey,),
                      Container(width: 10),
                      Text((widget.data['questionCount'] * 0.1).toString() + " minutes", style: TextStyle(color: Colors.grey))
                    ]
                  )
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
                        TakeSurvey(survey: widget.data, submitCallback: () {
                          tapCard();
                          Future.delayed(const Duration(milliseconds: 200), () => sendCard());
                        },)
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

class SurveyHero extends StatelessWidget {

  const SurveyHero({Key key, this.gradient, this.title, this.groups}) : super(key: key);

  final LinearGradient gradient;
  final String title;
  final List<String> groups;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        //image: DecorationImage(image: AssetImage("assets/forest.jpg"), fit: BoxFit.cover)
        gradient: gradient
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            title,
            style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Colors.white)),
          ),
          Container(height: 12),
          Tags(groups),
        ]
      )
    );
  }
}
