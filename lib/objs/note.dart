class Note {
  int id;
  String text;
  DateTime date;
  Note({this.id, this.text, this.date});

  /// integrating database, map function
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date.toString(),
    };
  }
}
