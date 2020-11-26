import 'package:flutter/material.dart';

class EditProfileModal extends StatefulWidget {

  EditProfileModal({Key key, this.name, this.email, this.callbackSet}) : super(key: key);

  final String name;
  final String email;
  final Function callbackSet;

  @override
  _EditProfileModalState createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  String _name;
  String _email;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
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
                        "Edit Profile",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                      ),
                      Text(
                        "Display name"
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
                        "Email address"
                      ),
                      TextFormField(
                        initialValue: _email,
                        maxLines: null,
                        onChanged: (value) => setState(() { _email = value; }),
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
                      onPressed: () async {
                        await widget.callbackSet(_name, _email);
                        Navigator.of(context).pop();
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