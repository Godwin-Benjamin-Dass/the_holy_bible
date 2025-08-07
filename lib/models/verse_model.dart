import 'dart:convert';

class VerseModel {
  int? id;
  int? book;
  int? chapter;
  int? verseNo;
  String? verseTam;
  String? verseEng;
  bool? isSelected;

  VerseModel({
    this.id,
    this.book,
    this.chapter,
    this.verseNo,
    this.verseTam,
    this.verseEng,
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
      verseTam: json["verse_tam"],
      verseEng: json["verse_eng"],
      isSelected: false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "book": book,
        "chapter": chapter,
        "verse_no": verseNo,
        "verse_tam": verseTam,
        "verse_eng": verseEng,
        "isSelected": isSelected,
      };
}
