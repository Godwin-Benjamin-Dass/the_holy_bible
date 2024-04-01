import 'dart:convert';

import 'package:holy_bible_tamil/models/verse_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkService {
  static String key = "bookMarks";

  static Future addBookMark(VerseModel verseModel) async {
    List bookMark = await getList();
    bookMark
        .add({"verse": verseModel.toJson(), "time": DateTime.now().toString()});
    saveList(bookMark);
  }

  static Future removeBookMark(VerseModel verseModel) async {
    List bookMark = await getList();
    bookMark.removeWhere((element) => element["verse"]["id"] == verseModel.id);
    saveList(bookMark);
  }

  static Future<List> getList() async {
    List bookMarks = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    bookMarks = jsonDecode(pref.getString(key) ?? "[]");
    return bookMarks;
  }

  static Future saveList(List bookMark) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, jsonEncode(bookMark));
  }
}
