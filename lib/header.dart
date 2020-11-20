import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catus/signin.dart';
import 'package:catus/profile.dart';

class Header extends StatelessWidget {

  const Header({Key key, this.showText, this.showProfile, this.text}) : super(key: key);

  final bool showText, showProfile;
  final String text;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 20.0, right: 20.0),
      child: Row(
        
        mainAxisAlignment: (!showText && showProfile) ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
        children: [
          if(showText) Text(text, style: Theme.of(context).textTheme.headline1),
          if(showProfile) ProfileButton()
        ]
      )
    );
  }
}

class ProfileButton extends StatefulWidget {

  @override _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton>{

  @override
  void initState(){
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) { setState((){}); });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "profileButton",
      child: ElevatedButton(
        clipBehavior: Clip.antiAlias,
        onPressed: () => Navigator.push(
          context,
          FirebaseAuth.instance.currentUser == null ? createPopup(SignIn(goToProfile: true,)) : MaterialPageRoute(
            builder: (context) => ProfilePage())
          ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(10.0),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(CircleBorder()),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          enableFeedback: true,
        ),
        child: Image(
              image: FirebaseAuth.instance.currentUser == null ? AssetImage("assets/anonUser.png") : AssetImage("assets/person.png"),
              fit: BoxFit.cover,
              width: 55.0,
              height: 55.0,
            )
      )
    );
  }
}