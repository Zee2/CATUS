import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:catus/takeSurvey.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:number_to_words/number_to_words.dart';
import "stringextension.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catus/groups.dart';
import 'package:catus/signin.dart';
import 'package:catus/editSurveyModal.dart';



class SurveyCard extends StatefulWidget {

  SurveyCard({Key key, this.data, this.authorMode = false}) : super(key: key){
  }
  final bool authorMode;
  // Key-value of survey data. Schemaless.. oh boy
  final QueryDocumentSnapshot data;
  final List<LinearGradient> gradients = [FlutterGradients.mindCrawl(),
      FlutterGradients.solidStone(),
      FlutterGradients.eternalConstance(),
      FlutterGradients.mindCrawl(),];

  @override
  _SurveyCardState createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> with TickerProviderStateMixin {

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

  void sendCard() async {
    isSent = true;
    
    await _sendController.forward().then((value) {
      if(!widget.authorMode)
        widget.data.reference.update({"completed": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid])});
      setState(() {});
    });
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
                  child: SurveyHero(widget.data, editable: widget.authorMode, title: widget.data['title'], groups: widget.data['groups'].cast<String>(), gradient: gradient)
                ),
                GestureDetector(
                  onTap: () {
                    // if outbox and open: edit survey, otherwise tap card
                    if (widget.data['draft'] && isExpanded) {
                      Navigator.push(context, createPopup(EditSurveyModal(
                        description: widget.data['description'],
                        name: widget.data['title'],
                        callbackSet: (description, name) {
                          widget.data.reference.update({"description": description, "title": name});
                        }
                      )));
                    } else tapCard();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    alignment: Alignment.topLeft,
                    child:Text(widget.data['description']),
                  )
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
                      Text((widget.data['questionCount'] * 0.1).toStringAsFixed(1) + " minutes", style: TextStyle(color: Colors.grey))
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
                        TakeSurvey(survey: widget.data, submitCallback: (){
                          tapCard();
                          return Future.delayed(const Duration(milliseconds: 200), () => sendCard());
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

  const SurveyHero(DocumentSnapshot this.doc, {Key key, this.editable = false, this.gradient, this.title, this.groups}) : super(key: key);
  final DocumentSnapshot doc;
  final LinearGradient gradient;
  final String title;
  final bool editable;
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
          Container(height: 8),
          GroupsEditor(doc, editable)
        ]
      )
    );
  }
}
