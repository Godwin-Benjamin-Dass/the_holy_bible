import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/models/verse_model.dart';

class VerseProvider extends ChangeNotifier {
  final List<VerseModel> allVerse = [];

  List<VerseModel> _verse = [];
  List<VerseModel> get verse => _verse;

  setverse(context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/bible_verse.json");
    final jsonResult = jsonDecode(data);
    allVerse.clear();
    for (var book in jsonResult) {
      allVerse.add(VerseModel.fromJson(book));
    }
    notifyListeners();
  }

  Future getVerses(
      {required int bookNo, required int chapterNo, required context}) async {
    _verse = allVerse
        .where(
            (element) => element.book == bookNo && element.chapter == chapterNo)
        .toList();
    notifyListeners();
    return _verse;
  }

  List<VerseModel> _searchVerse = [];
  List<VerseModel> get searchVerse => _searchVerse;

  Future filterSearchResults(String query) async {
    _searchVerse =
        allVerse.where((item) => item.verse!.contains(query)).toList();

    notifyListeners();
  }

  List _recentlyViewedVerse = [];
  List get recentlyViewedVerse => _recentlyViewedVerse;

  addRecentVerse(BooksModel book, int chapter, int? verse) {
    int idx = -1;
    for (int i = 0; i < _recentlyViewedVerse.length; i++) {
      if (_recentlyViewedVerse[i]["book"].name == book.name) {
        log("stage 1");
        if (_recentlyViewedVerse[i]["chapter"] == chapter) {
          log("stage 2");
          if (_recentlyViewedVerse[i]["verse"] == (verse ?? 1)) {
            log("stage 3");
            idx = i;
          }
        }
      }
    }
    log(idx.toString());
    if (idx != -1) {
      _recentlyViewedVerse.removeAt(idx);
    }
    _recentlyViewedVerse
        .add({"book": book, "chapter": chapter, "verse": verse ?? 1});
    notifyListeners();
  }
}
