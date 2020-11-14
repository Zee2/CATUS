import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Route createPopup(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SignIn(),
    opaque: false,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.white.withOpacity(0.5),
        child: Align(
          alignment: Alignment(0.5, -0.3),
          child: Stack(
            children: [
              // To ignore taps to go back
              GestureDetector(
                onTap: () {}, // Do nothing
                child: Container(
                  constraints: BoxConstraints(minWidth: 600.0),
                  margin: EdgeInsets.all(40.0),
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, offset: Offset(0,3))]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                        )
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                        )
                      ),
                      
                      
                    ],
                  )
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: (){},
                      backgroundColor: Colors.green,
                      icon: Icon(Icons.star_border),
                      label: Text("Sign up")
                    ),
                    Container(width: 20),
                    FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: (){},
                      icon: Icon(Icons.person),
                      label: Text("Sign in")
                    ),
                  
                  ]
                )
              )
              
            ]
          )
        )
      )
    );
  }
}