import 'dart:convert';

import 'package:flutter/material.dart';
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
    _searchVerse = allVerse
        .where((item) =>
            item.verse.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    notifyListeners();
  }
}
