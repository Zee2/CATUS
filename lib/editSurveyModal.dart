import 'package:flutter/material.dart';

class EditSurveyModal extends StatefulWidget {

  EditSurveyModal({Key key, this.description, this.name, this.callbackSet}) : super(key: key);

  final String description;
  final String name;
  final Function callbackSet;

  @override
  _EditSurveyModalState createState() => _EditSurveyModalState();
}

class _EditSurveyModalState extends State<EditSurveyModal> {
  String _description;
  String _name;

  @override
  void initState() {
    super.initState();
    _description = widget.description;
    _name = widget.name;
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
                        "Survey Settings",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                      ),
                      Text(
                        "Enter the name of this survey"
                      ),
                      TextFormField(
                        initialValue: _name,
                        maxLines: null,
                        onChanged: (value) => setState(() { _name = value; }),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                      ),
                      Text(
                        "Enter the description of this survey"
                      ),
                      TextFormField(
                        initialValue: _description,
                        maxLines: null,
                        onChanged: (value) => setState(() { _description = value; }),
                      )
                    ]
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
                        widget.callbackSet(_description, _name);
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