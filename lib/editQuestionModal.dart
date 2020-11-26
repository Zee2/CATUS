import 'package:flutter/material.dart';

class EditQuestionModal extends StatefulWidget {

  EditQuestionModal({Key key, this.description, this.callbackSet}) : super(key: key);

  final String description;
  final Function callbackSet;

  @override
  _EditQuestionModalState createState() => _EditQuestionModalState();
}

class _EditQuestionModalState extends State<EditQuestionModal> {
  String _description;

  @override
  void initState() {
    super.initState();
    _description = widget.description;
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
                        "Question Text",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        "Enter the display text for this question"
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Text",
                        ),
                        initialValue: _description,
                        maxLines: null,
                        onChanged: (value) => setState(() { _description = value; }),
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
                      onPressed: () {
                        widget.callbackSet(_description);
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