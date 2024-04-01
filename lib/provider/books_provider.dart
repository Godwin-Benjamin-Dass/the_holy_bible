import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/data/books.dart';
import 'package:holy_bible_tamil/models/books_model.dart';

class BooksProvider extends ChangeNotifier {
  final List<BooksModel> _oldTestament = [];
  List<BooksModel> get oldTestament => _oldTestament;

  final List<BooksModel> _newTestament = [];
  List<BooksModel> get newTestament => _newTestament;

  Future getOldTestament() async {
    _oldTestament.clear();
    for (var book in oldTestamentBooks) {
      _oldTestament.add(BooksModel.fromJson(book));
    }
    notifyListeners();
  }

  Future getNewTestament() async {
    _newTestament.clear();
    for (var book in newTestamentBooks) {
      _newTestament.add(BooksModel.fromJson(book));
    }
    notifyListeners();
  }
}
