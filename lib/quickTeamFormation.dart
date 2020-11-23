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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(names.length > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuickTeamResults(names, teamSize)),
              );
            }
          },
          child: Icon(Icons.shuffle),
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
                    onChanged: (value) => {teamSize = int.parse(value)},
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

class QuickTeamResults extends StatelessWidget {
  List<String> names = [];
  int teamSize;

  QuickTeamResults(List<String> names, int teamSize) {
    for (int i = 0; i < names.length; i++) {
      this.names.add(names[i]);
    }
    this.names.shuffle();

    this.teamSize = teamSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Results'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuickTeamResults(names, teamSize)),
          );
        },
        child: Icon(Icons.shuffle),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (BuildContext context, int index) {
                    Column members = Column(
                      children: [],
                    );

                    if (index % teamSize == 0) {
                      members.children.add(Container(
                        height: 20,
                        margin: EdgeInsets.all(2),
                        color: Colors.white,
                        child: Text("Team ${index ~/ teamSize + 1}"),
                      ));
                    }

                    members.children.add(Container(
                      height: 50,
                      margin: EdgeInsets.all(2),
                      color: Colors.blue[400],
                      child: Center(
                          child: Text(
                        '${names[index]}',
                        style: TextStyle(fontSize: 18),
                      )),
                    ));

                    return members;
                  }))
        ],
      ),
    );
  }
}
