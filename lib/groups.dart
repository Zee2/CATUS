import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:catus/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Tags extends StatelessWidget {
  const Tags(this.tags);

  final List<String> tags;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(tags.length, (index) {
      return Container(
          padding: EdgeInsets.only(right: 5), child: GroupTag(tags[index]));
    }));
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
