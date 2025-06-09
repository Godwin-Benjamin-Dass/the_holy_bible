import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:holy_bible_tamil/screens/home_flow/home_page.dart';
import 'package:provider/provider.dart';

class RecentlyViewVersePage extends StatelessWidget {
  const RecentlyViewVersePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recentVerse), actions: [
        IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
            },
            icon: const Icon(Icons.home))
      ]),
      body: Consumer<VerseProvider>(
        builder: (context, verse, child) => ListView.builder(
            itemCount: verse.recentlyViewedVerse.length,
            itemBuilder: (ctx, i) {
              BooksModel book =
                  verse.recentlyViewedVerse.reversed.toList()[i]["book"];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VersePage(
                                book: book,
                                chapter: verse.recentlyViewedVerse.reversed
                                    .toList()[i]["chapter"],
                                verseNo: verse.recentlyViewedVerse.reversed
                                    .toList()[i]["verse"],
                              )));
                },
                title: Text(
                  book.name ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "Chapter: ${verse.recentlyViewedVerse.reversed.toList()[i]["chapter"]}  Verse: ${verse.recentlyViewedVerse.reversed.toList()[i]["verse"]}"),
              );
            }),
      ),
    );
  }
}
