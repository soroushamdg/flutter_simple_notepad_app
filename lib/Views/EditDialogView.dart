import 'package:flutter/material.dart';
import 'package:simple_notepad/objs/note.dart';
import 'package:simple_notepad/services/database.dart';

class EditViewDialog extends StatelessWidget {
  bool newForm = true;
  Note editableNote;
  EditViewDialog({this.newForm, this.editableNote});
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (newForm != false && editableNote != null) {
      textController.text = editableNote.text;
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text((this.newForm) ? 'New note' : 'Edit note'),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'write your note here'),
            ),
            SizedBox(height: 25),
            RaisedButton(
              color: Color.fromRGBO(67, 99, 237, 1),
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (textController.text.isNotEmpty) {
                  if (this.newForm == true) {
                    //new note , add it to database
                    await DatabaseProvider().insertNote(Note(
                      id: await DatabaseProvider().queryRowCount() + 1,
                      date: DateTime.now(),
                      text: textController.text,
                    ));
                    Navigator.pop(context, {
                      'newNote': true,
                    });
                  } else {
                    //edit note and update database
                    editableNote.text = textController.text;
                    await DatabaseProvider().updateNote(editableNote);
                    Navigator.pop(context, {
                      'newNote': true,
                    });
                  }
                } else {
                  //just pop window
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
