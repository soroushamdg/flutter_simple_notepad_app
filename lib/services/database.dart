import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:simple_notepad/objs/note.dart';

class DatabaseProvider {
  static final String tableName = 'NOTESDB';

  // init database
  final Future<Database> database = openDatabase(
    join(getDatabasesPath().toString(), 'notes.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, text TEXT,date TEXT)');
    },
    version: 1,
  );

  // insert new item
  Future<void> insertNote(Note note) async {
    final Database db = await database;
    print(db);
    await db.insert(tableName, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // get number of all rows
  Future<int> queryRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // read full query of database
  Future<List<Note>> readDatabase() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      Note note = Note(
        id: maps[i]['id'],
        text: maps[i]['text'],
        date: DateTime.parse(maps[i]['date']),
      );
      return note;
    });
  }

  // update item in database
  Future<void> updateNote(Note note) async {
    final db = await database;

    await db.update(
      tableName,
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  // delete item from database
  Future<void> deleteNote(int id) async {
    final db = await database;

    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
