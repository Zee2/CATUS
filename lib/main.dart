import 'package:catus/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catus/surveylist.dart';
import 'package:catus/inbox.dart';
import 'package:firebase_core/firebase_core.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white.withOpacity(0.5),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // Firebase initialization future
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Inter',
        backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 50.0, color: Colors.black, fontWeight: FontWeight.w700, letterSpacing: -3.0),
          headline2: TextStyle(fontSize: 35.0, color: Colors.black, fontWeight: FontWeight.w700, letterSpacing: -0.5),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        ),
      ),
      home: FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white);
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return SwipeTabBar();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white);
        }
      ),
    );
  }
}

class SwipeTabBar extends StatefulWidget {
  @override
  _SwipeTabBarState createState() => _SwipeTabBarState();
}

class _SwipeTabBarState extends State<SwipeTabBar> {

  final _pageViewController = PageController();

  int _activePage = 0;

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          PageView(
            physics: BouncingScrollPhysics(),
            controller: _pageViewController,
            children: <Widget>[
              SurveyList(title: "Outbox", onlyOurs: false,),
              Inbox(),
              SurveyList(title: "Results", onlyOurs: false,),
            ],
            onPageChanged: (index) {
              setState(() {
                _activePage = index;
              });
            },
          ),
          SafeArea(child: Header( showText: false, showProfile: true, text: "",)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: () => {},
            child: Icon(Icons.add),
          ),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          elevation: 20.0,
          currentIndex: _activePage,
          onTap: (index) {
            _pageViewController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.send), label: "Outbox"),
            BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
            BottomNavigationBarItem(icon: Icon(Icons.stacked_line_chart), label: "Results"),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
