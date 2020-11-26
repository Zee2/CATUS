import 'package:flutter/material.dart';

class HomeFAB extends StatefulWidget {
  HomeFAB({Key key, this.children}) : super(key: key);

  final List<Widget> children;

  @override
  _HomeFABState createState() => _HomeFABState();
}

class _HomeFABState extends State<HomeFAB> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _open;

  @override
  void initState() {
    super.initState();
    _open = false;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: this.widget.children.map<Widget>((child) => FadeTransition(
          opacity: CurvedAnimation(
            parent: _controller,
            curve: new Interval(
              0.0,
              1.0,
              curve: Curves.easeInOut
            )
          ),
          child: IgnorePointer(
            ignoring: !_open,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: child
            )
          )
        )).toList()..add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                if (_open) _controller.reverse();
                else _controller.forward();
                setState(() { _open = !_open; });
              },
              child: Icon(Icons.add)
            ),
          )
        )
      );
  }
}
