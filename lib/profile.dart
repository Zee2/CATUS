import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:catus/groups.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Center(
              child: Container(
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
                              "John Doe",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(FirebaseAuth.instance.currentUser.email),
                            Text("Email verified: " +
                                FirebaseAuth.instance.currentUser.emailVerified
                                    .toString()),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupScreen()),
                                );
                              },
                              child: Text("Groups"),
                            )
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
            )));
  }
}
