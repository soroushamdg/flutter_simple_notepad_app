import 'package:flutter/material.dart';
import 'package:simple_notepad/objs/note.dart';
import 'package:simple_notepad/services/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Welcome"),
          content: new Text(
              "It seem it's your first time using the app, have fun! And if you had any idea, please don't hesitate to contribute on github."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Oki Doki"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home', arguments: {
                  'Notes': loadedNotes,
                });
              },
            ),
          ],
        );
      },
    );
  }

  List<Note> loadedNotes;
  bool loading = true;
  Future<void> loadNotes() async {
    setState(() {
      loading = true;
    });
    if (await DatabaseProvider().queryRowCount() == 0) {
      // show a welcome dialog and go to home view
      _showDialog();
    } else {
      // try loading database notes
      loadedNotes = await DatabaseProvider().readDatabase();
      if (loadedNotes != null) {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'Notes': loadedNotes,
        });
      } else {
        // failed to load database
        setState(() {
          loading = false;
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(67, 99, 237, 1),
      body: Center(
        child: (loading
            ? LoadingSpinnerView()
            : LoadingFailedView(func: () {
                loadNotes();
              })),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNotes();
  }
}

class LoadingSpinnerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitRotatingCircle(
      color: Colors.white,
      size: 50,
    );
  }
}

class LoadingFailedView extends StatelessWidget {
  final Function func;
  LoadingFailedView({this.func});
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
        onPressed: func, icon: Icon(Icons.refresh), label: Text('Retry'));
  }
}
