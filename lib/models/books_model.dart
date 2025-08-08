import 'dart:convert';

class BooksModel {
  String? nameT;
  String? nameE;
  int? bookNo;
  int? noOfBooks;

  BooksModel({
    this.nameT,
    this.nameE,
    this.bookNo,
    this.noOfBooks,
  });

  factory BooksModel.fromRawJson(String str) =>
      BooksModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
        nameT: json["nameT"],
        nameE: json["nameE"],
        bookNo: json["book_no"],
        noOfBooks: json["no_of_books"],
      );

  Map<String, dynamic> toJson() => {
        "nameT": nameT,
        "nameE": nameE,
        "book_no": bookNo,
        "no_of_books": noOfBooks,
      };
}
