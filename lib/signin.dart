import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catus/profile.dart';

Route createPopup(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
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

class SignIn extends StatefulWidget {

  const SignIn({Key key, this.goToProfile}) : super(key: key);

  final bool goToProfile;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String email = "", password = "";
  final _formKey = GlobalKey<FormState>(); // Key for validating signup form

  Future<UserCredential> userCred;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.white.withOpacity(0.5),
        child: Align(
          alignment: Alignment(0.0, -0.5),
          child: Stack(
            children: [
              // To ignore taps to go back
              GestureDetector(
                onTap: () {}, // Do nothing
                child: Container(
                  constraints: BoxConstraints(minWidth: 500.0, maxWidth: 600.0),
                  margin: EdgeInsets.all(40.0),
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, offset: Offset(0,3))]
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign in",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          "You need to login to do that."
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                          onChanged: (value) => email = value,
                          validator: (value) {
                            if(value.isEmpty)
                              return "Please enter your email";
                            else
                              return null;
                          }
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          onChanged: (value) => password = value,
                            
                          validator: (value) {
                            if(value.isEmpty)
                              return "Please enter your password";
                            else
                              return null;
                          }
                        ),
                        FutureBuilder(
                          future: userCred,
                          builder: (context, snapshot) {
                            if(snapshot.hasError){
                              return Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                    border: Border.all(color: Colors.red)
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    snapshot.error,
                                    style: TextStyle(color: Colors.red),
                                  )
                                )
                              );
                            }
                            return Container();
                          }
                        )
                      ],
                    )
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
                      onPressed: () {
                        Navigator.of(context).push(createPopup(SignUp(goToProfile: widget.goToProfile,)));
                      },
                      backgroundColor: Colors.green,
                      icon: Icon(Icons.star_border),
                      label: Text("Sign up")
                    ),
                    Container(width: 20),
                    FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: (){
                        final formState = _formKey.currentState;
                        if (formState.validate()) {
                          formState.save();
                          print("Signing user in, email = " + email);
                         
                          setState(() {
                            userCred = signIn(email, password);
                            userCred.then((userCred) {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              if(widget.goToProfile) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
                              }
                            });
                          });
                        }
                      },
                      backgroundColor: Colors.blue,
                      icon: Icon(Icons.switch_account),
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

class SignUp extends StatefulWidget {

  const SignUp({Key key, this.goToProfile}) : super(key: key);

  final bool goToProfile;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  String email = "", name = "", password = "", passwordConfirm = "";
  final _formKey = GlobalKey<FormState>(); // Key for validating signup form

  Future<UserCredential> userCred;

  // void initState() {
  //   super.initState();
  //   _controller = TextEditingController();
  // }

  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {}, // Don't let them quit signup.. for now
      child: Material(
        color: Colors.white.withOpacity(0.5),
        child: Align(
           alignment: Alignment(0.0, -0.5),
          child: Stack(
            children: [
              // To ignore taps to go back
              GestureDetector(
                onTap: () {}, // Do nothing
                child: Container(
                  constraints: BoxConstraints(minWidth: 500.0, maxWidth: 600.0),
                  margin: EdgeInsets.all(40.0),
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [BoxShadow(color:Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 20, offset: Offset(0,3))]
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign up",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          "Create a new account"
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                          onChanged: (value) => email = value,
                          validator: (value) {
                            if(value.isEmpty)
                              return "Please enter your email";
                            else
                              return null;
                          }
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Name",
                          ),
                         onChanged: (value) => name = value,
                          validator: (value) {
                            if(value.isEmpty)
                              return "Please enter your name";
                            else
                              return null;
                          }
                        ),
                        TextFormField(
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          onChanged: (value) => password = value,
                            
                          validator: (value) {
                            if(value.isEmpty)
                              return "Please enter your password";
                            else
                              return null;
                          }
                        ),
                        TextFormField(
                          obscureText: false,
                          
                          decoration: InputDecoration(
                            labelText: "Confirm password",
                          ),
                          onChanged: (value) => passwordConfirm = value,
                          validator: (value) {
                            print("Password: " + password);
                            if(value.isEmpty){
                              return "Please enter your password";
                            }
                            else if(value != password){
                              return "Password does not match";
                            }
                            else
                              return null;
                          }
                        ),
                        FutureBuilder(
                          future: userCred,
                          builder: (context, snapshot) {
                            if(snapshot.hasError){
                              return Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                    border: Border.all(color: Colors.red)
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    snapshot.error,
                                    style: TextStyle(color: Colors.red),
                                  )
                                )
                              );
                            }
                            return Container();
                          }
                        )
                      ],
                    )
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
                      onPressed: (){
                        final formState = _formKey.currentState;
                        if (formState.validate()) {
                          formState.save();
                          print("Creating user, email = " + email);
                         
                          setState(() {
                            userCred = createUser(email, password, name);
                            userCred.then((userCred) {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              if(widget.goToProfile) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
                              }
                            });
                          });
                        }
                      },
                      backgroundColor: Colors.green,
                      icon: Icon(Icons.star_border),
                      label: Text("Sign up")
                    )
                  
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

Future<UserCredential> createUser(String email, String password, String name) async {
  String errorMessage;
  UserCredential result;
  try {
    result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch(e) {
    print("Catching firebase auth exception");
    errorMessage = getMessageFromErrorCode(e.code);
    print("Error code parsed; " + errorMessage);
  } catch(e) {
    print("Catching generic exception");
    print(e);
  }

  if (errorMessage != null) {
    return Future.error(errorMessage);
  }
  await result.user.updateProfile(displayName: name);
  await FirebaseFirestore.instance.collection("users").doc(result.user.uid).set({'name': name});

  await FirebaseFirestore.instance.collection('surveys').add(
    {
      'author': "Big Brother",
      'completed': [],
      'description': 'This is an example survey, automatically created for you when you created your new account. This survey, along with quite a lot of metadata and all the questions/responses are stored on our Firebase realtime backend.',
      'draft': false,
      'groups': [],
      'questionCount': 3,
      'recipients': [
        result.user.uid
      ],
      'title': 'Example Survey'
    }
  ).then((value) {
    value.collection('questions').add(
      {
        'ordering': 1,
        'prompt': 'There are several questions in this survey. Feel free to answer them! How are you feeling today?',
        'type': 'text'
      }
    );
    value.collection('questions').add(
      {
        'ordering': 2,
        'prompt': 'There are also numerical-input questions. Rate, from 1-5, how cute your favorite pet is...',
        'type': 'rate'
      }
    );
    value.collection('questions').add(
      {
        'ordering': 3,
        'prompt': 'Your responses are streamed in realtime to the database, and you never need to save your answers. Now, for the last question.... what is the meaning of life?',
        'type': 'text'
      }
    );
  });
  
  return result;
}

Future<UserCredential> signIn(String email, String password) async {
  String errorMessage;
  UserCredential result;
  try {
    result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch(e) {
    print("Catching firebase auth exception");
    errorMessage = getMessageFromErrorCode(e.code);
    print("Error code parsed; " + errorMessage);
  } catch(e) {
    print("Catching generic exception");
    print(e);
  }

  if (errorMessage != null) {
    return Future.error(errorMessage);
  }

  return result;
}

//https://stackoverflow.com/questions/56113778/how-to-handle-firebase-auth-exceptions-on-flutter
String getMessageFromErrorCode(errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used.";
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
        break;
      case "ERROR_WEAK_PASSWORD":
      case "weak-password":
        return "Your password is too weak.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
        break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No account found with this email";
        break;
      default:
        return "Login failed. Please try again.";
        break;
    }
  }