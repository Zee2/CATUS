import 'package:catus/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catus/surveylist.dart';
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white.withOpacity(0.5),
      statusBarIconBrightness: Brightness.dark,
      //systemNavigationBarIconBrightness: Brightness.light,
    ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: SwipeTabBar(),
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
              SurveyList(title: "Outbox"),
              SurveyList(title: "Inbox"),
              SurveyList(title: "Results"),
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
      bottomNavigationBar: BottomNavigationBar(
            currentIndex: _activePage,
            onTap: (index) {
              _pageViewController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.send), label: "Outbox"),
              BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
              BottomNavigationBarItem(icon: Icon(Icons.stacked_line_chart), label: "Results"),
            ],
      )
    );
  }
}
