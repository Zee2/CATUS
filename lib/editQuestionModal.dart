import 'package:flutter/material.dart';

class EditQuestionModal extends StatefulWidget {

  EditQuestionModal({Key key, this.description, this.type, this.callbackSet}) : super(key: key);

  final String description;
  final String type;
  final Function callbackSet;

  @override
  _EditQuestionModalState createState() => _EditQuestionModalState();
}

class _EditQuestionModalState extends State<EditQuestionModal> {
  String _description;
  String _type;

  @override
  void initState() {
    super.initState();
    _description = widget.description;
    _type = widget.type;
  }

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Question Settings",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                      ),
                      Text(
                        "Enter the display text for this question"
                      ),
                      TextFormField(
                        initialValue: _description,
                        maxLines: null,
                        onChanged: (value) => setState(() { _description = value; }),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                      ),
                      Text(
                        "Select the response type"
                      ),
                      DropdownButton<String>(
                        value: _type,
                        items: [
                          DropdownMenuItem(child: Text("Rate slider"), value: "rate"),
                          DropdownMenuItem(child: Text("Text box"), value: "text")
                        ],
                        onChanged: (value) => setState(() { _type = value; }),
                      )
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
                      onPressed: () {
                        widget.callbackSet(_description, _type);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      backgroundColor: Colors.blue,
                      label: Text("Submit")
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