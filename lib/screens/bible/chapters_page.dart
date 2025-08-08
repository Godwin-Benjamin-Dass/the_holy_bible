import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:holy_bible_tamil/screens/home_flow/home_page.dart';
import 'package:provider/provider.dart';

class ChaptersPage extends StatelessWidget {
  const ChaptersPage({super.key, required this.book});
  final BooksModel book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ThemeProvider>(
            builder: (context, theme, child) => Tooltip(
                  message: theme.format == 'onlyTamil'
                      ? book.nameT!
                      : theme.format == 'onlyEnglish'
                          ? book.nameE!
                          : theme.format == 'tamilEnglish'
                              ? book.nameT! + '/' + book.nameE!
                              : book.nameE! + '/' + book.nameT!,
                  child: AutoSizeText(
                      theme.format == 'onlyTamil'
                          ? book.nameT!
                          : theme.format == 'onlyEnglish'
                              ? book.nameE!
                              : theme.format == 'tamilEnglish'
                                  ? book.nameT! + '/' + book.nameE!
                                  : book.nameE! + '/' + book.nameT!,
                      maxFontSize: 17,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                )),
      ),
      body: GridView.builder(
          itemCount: book.noOfBooks,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (ctx, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VersePage(book: book, chapter: i + 1)));
                },
                child: Card(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      (i + 1).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .fontSize),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
