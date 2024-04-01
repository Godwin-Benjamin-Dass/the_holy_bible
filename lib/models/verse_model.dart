import 'dart:convert';

class VerseModel {
  int? id;
  int? book;
  int? chapter;
  int? verseNo;
  String? verse;
  bool? isSelected;

  VerseModel({
    this.id,
    this.book,
    this.chapter,
    this.verseNo,
    this.verse,
    this.isSelected,
  });

  factory VerseModel.fromRawJson(String str) =>
      VerseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerseModel.fromJson(Map<String, dynamic> json) => VerseModel(
      id: json["id"],
      book: json["book"],
      chapter: json["chapter"],
      verseNo: json["verse_no"],
      verse: json["verse"],
      isSelected: false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "book": book,
        "chapter": chapter,
        "verse_no": verseNo,
        "verse": verse,
      };
}
