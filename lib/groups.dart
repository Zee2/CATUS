

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Tags extends StatelessWidget {
  const Tags(this.tags);

  final List<String> tags;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tags.length, (index) {
        return Container(
          padding: EdgeInsets.only(right: 5),
          child: GroupTag(tags[index])
        );  
      })
    );
  }
}

class GroupTag extends StatelessWidget{

  const GroupTag(this.text);

  final String text;
  final Color color = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        //border: Border.all(color: Colors.white, width: 2.0),
        color: Colors.black.withOpacity(0.3)
      ),
      child: Padding(
        padding: EdgeInsets.only(left:11.0, right: 11.0, top: 5.0, bottom: 4.0),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 15),),
      )
    );
  }
}