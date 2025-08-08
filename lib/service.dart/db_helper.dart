// utils/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'notes.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT,
          date TEXT
        )
      ''');
    });
  }

  static Future<void> insertNote(
      String title, String content, String date) async {
    final db = await database;
    await db.insert('notes', {
      'title': title,
      'content': content,
      'date': date,
    });
  }

  static Future<void> updateNote(int id, String title, String content) async {
    final db = await database;
    await db.update(
      'notes',
      {'title': title, 'content': content},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes', orderBy: 'id DESC');
  }
}
