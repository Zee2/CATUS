import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:catus/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupsEditor extends StatefulWidget {

  const GroupsEditor(this.doc, this.editable);

  final DocumentSnapshot doc;
  final bool editable;

  @override
  _GroupsEditorState createState() => _GroupsEditorState();
}

class _GroupsEditorState extends State<GroupsEditor>{

  Stream<DocumentSnapshot> documentStream;
  Future<QuerySnapshot> groupsQuery;

  @override
  void initState() {
    super.initState();
    documentStream = widget.doc.reference.snapshots();
    groupsQuery = FirebaseFirestore.instance.collection('groups').get();
  }

  @override
  Widget build(BuildContext context) {

    // if(!widget.editable){
    //   return Row(
    //     children: List.generate(tags.length, (index) {
    //       return Container(
    //           padding: EdgeInsets.only(right: 5), child: GroupTag(tags[index]));
    //     }));
    // }
    return FutureBuilder(
      future: groupsQuery,
      builder: (context, AsyncSnapshot<QuerySnapshot> groups) {
        if(!groups.hasData){
          return Container();
        }
        return StreamBuilder(
          stream: documentStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> value) {
            if(!value.hasData) {
              return Container();
            } else {
              if(!widget.editable) {
                return Wrap(
                  spacing: 8,
                  runSpacing: -10,
                  children: List<Widget>.generate(groups.data.docs.length, (groupIndex) {
                      if((value.data.data()['groups'].cast<String>()).contains(groups.data.docs[groupIndex].data()['name'])){
                        //return GroupTag(groups.data.docs[groupIndex].data()['name']);
                        return Theme(
                          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                          child: FilterChip(
                            selectedColor: Colors.white,
                            backgroundColor: Colors.black.withOpacity(0.3),
                            labelStyle: DefaultTextStyle.of(context).style.copyWith(color: MaterialStateColor.resolveWith((states) {
                              return states.contains(MaterialState.selected) ? Colors.black : Colors.white;
                            })),
                            label: Text(groups.data.docs[groupIndex].data()['name']),
                            onSelected: (selected) {}
                          )
                        );
                      } else {
                        return Container(width:0);
                      }
                    }
                  )
                );
              } else {
                return Wrap(
                  spacing: 8,
                  runSpacing: -10,
                  children: List<Widget>.generate(groups.data.docs.length, (groupIndex) {
                    
                    return Theme(
                      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                      child: FilterChip(
                        selectedColor: Colors.white,
                        backgroundColor: Colors.black.withOpacity(0.3),
                        labelStyle: DefaultTextStyle.of(context).style.copyWith(color: MaterialStateColor.resolveWith((states) {
                          return states.contains(MaterialState.selected) ? Colors.black : Colors.white;
                        })),
                        selected: (value.data.data()['groups'].cast<String>()).contains(groups.data.docs[groupIndex].data()['name']),
                        label: Text(groups.data.docs[groupIndex].data()['name']),
                        onSelected: (selected) {
                          if(selected) {
                            value.data.reference.update({'groups': FieldValue.arrayUnion([groups.data.docs[groupIndex].data()['name']])});
                          } else {
                            value.data.reference.update({'groups': FieldValue.arrayRemove([groups.data.docs[groupIndex].data()['name']])});
                          }
                        }
                      )
                    );
                  })
                );
              }
              
            }
          }
        );
      }
    );
    
    
    // 
  }
}

class GroupTag extends StatelessWidget {
  const GroupTag(this.text);

  final String text;
  final Color color = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            //border: Border.all(color: Colors.white, width: 2.0),
            color: Colors.black.withOpacity(0.3)),
        child: Padding(
          padding:
              EdgeInsets.only(left: 11.0, right: 11.0, top: 5.0, bottom: 4.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ));
  }
}

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  Stream<QuerySnapshot> userGroups;

  @override
  void initState() {
    super.initState();

    var user = FirebaseAuth.instance.currentUser;
    userGroups = FirebaseFirestore.instance
        .collection("groups")
        .where('users', arrayContains: user.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: userGroups,
        builder: (context, snapshot) {
          print("Streambuilder Test!");

          if (snapshot.hasError) {
            print("Snapshot error: " + snapshot.error.toString());
            return Text("Something wrong!");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Snapshot waiting");
            return Text("Something wrong!");
          }

          print("Found " + snapshot.data.docs.length.toString() + "documents");

          List<Widget> listElements = [];
          listElements.add(SafeArea(
              child: Header(
            text: "Groups",
            showProfile: false,
            showText: true,
          )));

          for (DocumentSnapshot doc in snapshot.data.docs) {
            listElements.add(Text(
              doc['name'],
              style: Theme.of(context).textTheme.headline4,
            ));
          }

          listElements.add(ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGroups()),
              );
            },
            child: Text("Add Groups"),
          ));

          return Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Column(
              children: listElements,
            ),
          );
        });
  }
}

class AddGroups extends StatefulWidget {
  @override
  _AddGroupsState createState() => _AddGroupsState();
}

class _AddGroupsState extends State<AddGroups> {
  Stream<QuerySnapshot> allGroups;

  @override
  void initState() {
    super.initState();

    allGroups = FirebaseFirestore.instance.collection("groups").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: allGroups,
        builder: (context, snapshot) {
          print("Streambuilder Test!");

          if (snapshot.hasError) {
            print("Snapshot error: " + snapshot.error.toString());
            return Text("Something wrong!");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Snapshot waiting");
            return Text("Something wrong!");
          }

          print("Found " + snapshot.data.docs.length.toString() + "documents");

          List<Widget> listElements = [];
          listElements.add(SafeArea(
              child: Header(
            text: "Add Groups",
            showProfile: false,
            showText: true,
          )));

          for (DocumentSnapshot doc in snapshot.data.docs) {
            listElements.add(ElevatedButton(
              child: Text(doc['name']),
              onPressed: () {
                // Ideally store this user's uid to the group
              },
            ));
          }

          return Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Column(
              children: listElements,
            ),
          );
        });
  }
}
