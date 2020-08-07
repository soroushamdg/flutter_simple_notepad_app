import 'package:flutter/material.dart';
import 'package:simple_notepad/Views/EditDialogView.dart';
import 'package:simple_notepad/Views/HomeView.dart';
import 'package:simple_notepad/Views/LoadingView.dart';

void main() {
  runApp(
    MaterialApp(initialRoute: '/', routes: {
      '/': (context) => LoadingView(),
      '/home': (context) => HomeView(),
      '/edit': (context) => EditViewDialog(),
    }),
  );
}
