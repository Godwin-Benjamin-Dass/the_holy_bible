import 'dart:convert';
import 'dart:developer';

import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContinueReadingService {
  static String key = "crs";

  static Future setData(
      {required BooksModel book, required int chapter}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = {"book": book.toJson(), "chapter": chapter};
    log(data.toString());
    pref.setString(key, jsonEncode(data));
  }

  static Future getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String spdata = pref.getString(key) ?? "";
    if (spdata == "") {
      return null;
    } else {
      var data = jsonDecode(spdata);
      BooksModel bm = BooksModel.fromJson(data["book"]);
      int c = data["chapter"];
      return {"book": bm, "chapter": c};
    }
  }
}