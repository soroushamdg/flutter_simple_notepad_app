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
        body: NotesList(notes: notes),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            dynamic dialogData = await showDialog(
              context: context,
              builder: (BuildContext context) => EditViewDialog(
                newForm: true,
                editableNote: null,
              ),
            );
            if (dialogData != null) {
              if (dialogData.isNotEmpty) {
                if (dialogData['newNote']) {
                  setState(() {
                    notes.add(dialogData['note']);
                  });
                }
              }
            }
          },
        ));
  }
}

class NotesList extends StatefulWidget {
  final List<Note> notes;
  NotesList({this.notes});

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (this.widget.notes != null) ? widget.notes.length : 0,
      itemBuilder: (context, index) {
        index = widget.notes.length - index - 1;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Card(
            child: ListTile(
              onTap: () async {
                dynamic dialogData = await showDialog(
                  context: context,
                  builder: (BuildContext context) => EditViewDialog(
                    newForm: false,
                    editableNote: widget.notes[index],
                  ),
                );
                if (dialogData != null) {
                  if (dialogData.isNotEmpty) {
                    if (dialogData['newNote']) {
                      setState(() {
                        widget.notes[index] = dialogData['note'];
                      });
                    }
                  }
                }
              },
              title: Text((widget.notes[index].text.length <= 50)
                  ? widget.notes[index].text
                  : widget.notes[index].text.substring(0, 45) + '...'),
              subtitle: Text(DateFormat.Hm().format(widget.notes[index].date)),
            ),
          ),
        );
      },
    );
  }
}
