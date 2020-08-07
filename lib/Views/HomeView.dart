import 'package:flutter/material.dart';
import 'package:simple_notepad/objs/note.dart';
import 'package:intl/intl.dart';
import 'package:simple_notepad/Views/EditDialogView.dart';
import 'package:simple_notepad/services/database.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> notes;
  Map data = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    notes = data['Notes'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Notes'),
          backgroundColor: Color.fromRGBO(67, 99, 237, 1),
        ),
        body: NotesList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => EditViewDialog(
                newForm: true,
                editableNote: null,
              ),
            );
            setState(() {});
          },
        ));
  }
}

class NotesList extends StatelessWidget {
  final List<Note> notes;
  NotesList({this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (this.notes != null) ? notes.length : 0,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          child: Card(
            child: ListTile(
              onTap: () {},
              title: Text((notes[index].text.length <= 50)
                  ? notes[index].text
                  : notes[index].text.substring(0, 49)),
              subtitle: Text(DateFormat.Hm().format(notes[index].date)),
            ),
          ),
        );
      },
    );
  }
}
