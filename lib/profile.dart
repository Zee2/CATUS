import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:catus/groups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage>{

  Stream<QuerySnapshot> groupsStream;
  Stream<QuerySnapshot> groupMembershipStream;

  Map<String, bool> localGroupStatus;

  @override
  void initState() {
    super.initState();

    groupsStream = FirebaseFirestore.instance.collection('groups').snapshots();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 500.0),
                    margin: EdgeInsets.only(left:20.0, right: 20.0, top: 20.0),
                    child: Row(children: [
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back
                        )
                      )
                    ],)
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500.0),
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 20,
                              offset: Offset(0, 3))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FirebaseAuth.instance.currentUser.displayName ?? "",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                Text(FirebaseAuth.instance.currentUser.email),
                                Text("Email verified: " +
                                    FirebaseAuth.instance.currentUser.emailVerified
                                        .toString())
                              ],
                            ),
                            Hero(
                                tag: "profileButton",
                                child: ElevatedButton(
                                    clipBehavior: Clip.antiAlias,
                                    onPressed: () => {},
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(10.0),
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.white),
                                      shape:
                                          MaterialStateProperty.all(CircleBorder()),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      enableFeedback: true,
                                    ),
                                    child: StreamBuilder<User>(
                                      stream:
                                          FirebaseAuth.instance.authStateChanges(),
                                      builder: (context, value) {
                                        return Image(
                                          image: value == null
                                              ? AssetImage("assets/anonUser.png")
                                              : AssetImage("assets/person.png"),
                                          fit: BoxFit.cover,
                                          width: 120.0,
                                          height: 120.0,
                                        );
                                      },
                                      // Doesn't work correctly; needs to redraw/set state on auth state change
                                    ))),
                          ],
                        ),
                        //Container(height: 40,),
                        // Text("Profile uid: " + FirebaseAuth.instance.currentUser.uid),
                        Row(
                          children: [
                            FloatingActionButton.extended(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pop();
                                },
                                heroTag: null,
                                backgroundColor: Colors.redAccent,
                                label: Text("SIGN OUT"),
                                icon: Icon(Icons.close))
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500.0),
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 20,
                              offset: Offset(0, 3))
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Groups", style: Theme.of(context).textTheme.headline3,),
                        Text("Select groups to recieve surveys from that group."),
                        Container(height: 10),
                        StreamBuilder(
                          stream: groupsStream,
                          builder: (context, AsyncSnapshot<QuerySnapshot> value) {
                            if(!value.hasData) {
                              return Container();
                            } else {
                              return Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: List<Widget>.generate(value.data.docs.length, (index) {
                                  return FilterChip(
                                    selectedColor: Colors.lightBlueAccent,
                                    
                                    selected: (value.data.docs[index].data()['users'].cast<String>()).contains(FirebaseAuth.instance.currentUser.uid),
                                    label: Text(value.data.docs[index].data()['name']),
                                    onSelected: (selected) {
                                      if(selected) {
                                        value.data.docs[index].reference.update({'users': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid])});
                                      } else {
                                        value.data.docs[index].reference.update({'users': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid])});
                                      }
                                    }
                                  );
                                })
                              );
                            }
                          }
                        )
                      ]
                    )
                  )
            ],
          )
      )));
  }
}
