import 'dart:convert';

class BooksModel {
  String? name;
  int? bookNo;
  int? noOfBooks;

  BooksModel({
    this.name,
    this.bookNo,
    this.noOfBooks,
  });

  factory BooksModel.fromRawJson(String str) =>
      BooksModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
        name: json["name"],
        bookNo: json["book_no"],
        noOfBooks: json["no_of_books"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "book_no": bookNo,
        "no_of_books": noOfBooks,
      };
}
