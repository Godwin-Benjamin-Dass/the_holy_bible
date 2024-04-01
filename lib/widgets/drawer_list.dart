import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/screens/bible/chapters_page.dart';
import 'package:provider/provider.dart';

class DrawerList extends StatelessWidget {
  const DrawerList({super.key, required this.books, this.isFromHome = false});
  final List<BooksModel> books;
  final bool isFromHome;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: books.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          BooksModel book = books[i];
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChaptersPage(
                            book: book,
                          )));
            },
            leading: Text(
              book.bookNo.toString(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            title: Text(
              book.name!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Provider.of<ThemeProvider>(context, listen: false)
                      .fontSize),
            ),
            trailing: Text(
              book.noOfBooks.toString(),
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          );
        });
  }
}
