import 'package:flutter/material.dart';
import 'package:catus/header.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuickTeamFormation extends StatefulWidget {
  @override
  _QuickTeamFormationState createState() => _QuickTeamFormationState();
}

class _QuickTeamFormationState extends State<QuickTeamFormation> {
  final _formKey = GlobalKey<FormState>(); // Key for validating form

  String eventName = "";
  int teamSize = 1;
  final List<String> names = <String>[];

  TextEditingController nameController = TextEditingController();

  void addMemberToList() {
    setState(() {
      if (nameController.text != '') {
        List<String> listOfNames = nameController.text.split(",");
        listOfNames.map((s) => s.trim());
        names.addAll(listOfNames);
        nameController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(names.length > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuickTeamResults(names, teamSize)),
            );
          }
        },
        child: Icon(Icons.shuffle),
      ),
      body: Column(
        children: [
          SafeArea(
            child: Header(
              text: "Quick Team",
              showProfile: false,
              showText: true,
            )
          ),
          Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(  
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, offset: Offset(0,3))]
              ),
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 20.0),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Event Name",
                    ),
                    onChanged: (value) => {eventName = value},
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter your event name";
                      else
                        return null;
                    }
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Team Size",
                    ),
                    onChanged: (value) => {teamSize = int.parse(value)},
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter your team size";
                      else
                        return null;
                    }
                  ),
                  Container(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Add Member Name',
                          ),
                        ),
                      ),
                      Container(width: 20.0),
                      FloatingActionButton.extended(
                        onPressed: () => addMemberToList(),
                        heroTag: null,
                        backgroundColor: Colors.blueAccent,
                        label: Text("ADD"),
                        icon: Icon(Icons.add)
                      )
                    ],
                  )
                  
                ]
              ),
            )
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        runAlignment: WrapAlignment.start,
                        alignment: WrapAlignment.center,
                        children: List.generate(names.length, (index) {
                          return Chip(
                            elevation: 12.0,
                            shadowColor: Colors.black.withOpacity(0.5),
                            backgroundColor: Colors.white,
                            avatar: Icon(Icons.person
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            label: Text(names[index])
                          );
                        })
                      )
                )
              )
              
            ],
          )
          
          
        ]
      )
    );
  }
}

class DatabasePersonBubble extends StatelessWidget {
  const DatabasePersonBubble({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot> usernameQuery = FirebaseFirestore.instance.collection("users").doc(uid).get();
    return FutureBuilder(
      future: usernameQuery,
      builder: (context, userDoc) {
        try {
          return PersonBubble(name: userDoc.data['name']);
        } catch(e){
          return PersonBubble(name: "Anon");
        }
      }
    );
  }
}

class PersonBubble extends StatelessWidget {

  const PersonBubble({Key key, this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: 60.0,
          height: 60.0,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(  
            color: Colors.white,
            shape: BoxShape.circle,
            // borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 2.0, color: Theme.of(context).accentColor)
            //boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.5), spreadRadius: 0, blurRadius: 20, offset: Offset(0,1))]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Image(
                image: AssetImage("assets/anonUser.png"),
                fit: BoxFit.cover,
                width: 55.0,
                height: 55.0,
              )
          )
        ),
        Container(
          margin: EdgeInsets.only(top:5.0),
          child: Text(
            this.name,
            textAlign: TextAlign.center,
          )
        )
      ],
      
    );
  }
}

class QuickTeamResults extends StatelessWidget {
  List<String> names = [];
  int teamSize;

  QuickTeamResults(List<String> names, int teamSize) {
    for (int i = 0; i < names.length; i++) {
      this.names.add(names[i]);
    }
    this.names.shuffle();

    this.teamSize = teamSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Icon(Icons.close),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[Header(
          text: "Results",
          showProfile: false,
          showText: true,
        )] + List.generate((names.length / teamSize).ceil(), (teamIndex) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, offset: Offset(0,3))]
            ),
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 0.0),
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TEAM ${teamIndex + 1}", style: Theme.of(context).textTheme.bodyText1.copyWith(
                  letterSpacing: 2.0,

                )),
                Container(height: 20.0),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:  3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: teamSize,
                    itemBuilder: (BuildContext context, int nameIndex) {
                      try {
                        return PersonBubble(name: names[teamIndex * teamSize + nameIndex]);
                      } catch (re){
                        return Container();
                      }
                    }
                  )
              ],
            )
          );

          // return members;
        }) + [
          // reshuffle and edit buttons
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: RaisedButton(
              elevation: 10,
              child: Container(
                height: 50.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Re-shuffle Team', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                  ]
                )
              ),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuickTeamResults(names, teamSize)),
                );
              }
            )
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: RaisedButton(
              elevation: 10,
              child: Container(
                height: 50.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Edit Team', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                  ]
                )
              ),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
            )
          )
        ]
      )
    );
  }
}
