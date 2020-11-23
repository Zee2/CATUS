import 'package:flutter/material.dart';

class QuickTeamFormation extends StatefulWidget {
  @override
  _QuickTeamFormationState createState() => _QuickTeamFormationState();
}

class _QuickTeamFormationState extends State<QuickTeamFormation> {

  final _formKey = GlobalKey<FormState>(); // Key for validating form

  String eventName = "";
  int teamSize = 1;
  final List<String> names = <String>[];

  TextEditingController nameController = TextEditingController();

  void addMemberToList() {
    setState(() {
      if (nameController.text != '') {
        names.add(nameController.text);
        nameController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quick Team Formation'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Event Name",
                    ),
                    onChanged: (value) => {eventName = value},
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter your event name";
                      else
                        return null;
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Team Size",
                    ),
                    onChanged: (value) => {teamSize = value as int},
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter your team size";
                      else
                        return null;
                    }),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Member Name',
                  ),
                ),
                RaisedButton(
                  child: Text('Add Member'),
                  onPressed: () {
                    addMemberToList();
                  },
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: names.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            margin: EdgeInsets.all(2),
                            color: Colors.blue[400],
                            child: Center(
                                child: Text(
                              '${names[index]}',
                              style: TextStyle(fontSize: 18),
                            )),
                          );
                        }))
              ]),
            )));
  }
}
