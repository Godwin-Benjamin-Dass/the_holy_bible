// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/models/verse_model.dart';
import 'package:holy_bible_tamil/provider/books_provider.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:holy_bible_tamil/screens/bible/book_page.dart';
import 'package:holy_bible_tamil/screens/bible/recent_viewed_verse_page.dart';
import 'package:holy_bible_tamil/screens/bible/search_page.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:holy_bible_tamil/screens/book_mark/book_marks.dart';
import 'package:holy_bible_tamil/screens/home_flow/settings_page.dart';
import 'package:holy_bible_tamil/service.dart/continue_reading_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getChapters();
  }

  getChapters() async {
    Future.delayed(Duration.zero, () async {
      await Provider.of<BooksProvider>(context, listen: false)
          .getOldTestament();
      await Provider.of<BooksProvider>(context, listen: false)
          .getNewTestament();
      if (Provider.of<VerseProvider>(context, listen: false).allVerse.isEmpty) {
        await Provider.of<VerseProvider>(context, listen: false)
            .setverse(context);
      }
    });
    getBookName(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeTile(
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BooksPage()));
                },
                title: holyBibeName,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeTile(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BooksPage()));
                    },
                    title: oldTestamentName,
                  ),
                  HomeTile(
                    ontap: () async {
                      var data = await ContinueReadingService.getData();
                      if (data == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VersePage(
                                    isFromHome: true,
                                    book: BooksModel(
                                        bookNo: 1,
                                        noOfBooks: 50,
                                        name: "ஆதியாகமம்"),
                                    chapter: 1)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VersePage(
                                      isFromHome: true,
                                      book: data["book"],
                                      chapter: data["chapter"],
                                      verseNo: data["verse"],
                                    )));
                      }
                    },
                    title: continueReadingName,
                  ),
                  HomeTile(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BooksPage(
                                    idx: 1,
                                  )));
                    },
                    title: newTestamentName,
                  ),
                ],
              ),
              HomeTile(
                ontap: () async {
                  BooksModel books =
                      Provider.of<BooksProvider>(context, listen: false)
                          .oldTestament
                          .first;
                  List chapters = [];
                  String selected_book = "1";
                  for (int i = 0; i < 50; i++) {
                    chapters.add(i + 1);
                  }
                  List<VerseModel> verse =
                      await Provider.of<VerseProvider>(context, listen: false)
                          .getVerses(bookNo: 1, chapterNo: 1, context: context);
                  VerseModel selected_verse =
                      Provider.of<VerseProvider>(context, listen: false)
                          .verse
                          .first;
                  List<BooksModel> book =
                      Provider.of<BooksProvider>(context, listen: false)
                              .oldTestament +
                          Provider.of<BooksProvider>(context, listen: false)
                              .newTestament;

                  showDialog(
                      context: context,
                      builder: (_) =>
                          StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Text(referece),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButton(
                                    value: books,
                                    items: book.map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.name!),
                                      );
                                    }).toList(),
                                    onChanged: (val) async {
                                      books = val!;
                                      log(books.toRawJson());
                                      selected_book = "1";
                                      verse = await Provider.of<VerseProvider>(
                                              context,
                                              listen: false)
                                          .getVerses(
                                              bookNo: books.bookNo!,
                                              chapterNo: 1,
                                              context: context);
                                      selected_verse =
                                          Provider.of<VerseProvider>(context,
                                                  listen: false)
                                              .verse
                                              .first;
                                      chapters.clear();
                                      for (int i = 0;
                                          i < books.noOfBooks!;
                                          i++) {
                                        chapters.add(i + 1);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DropdownButton<String>(
                                        value: selected_book,
                                        items: chapters.map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value.toString(),
                                            child: Text(value.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (val) async {
                                          selected_book = val!.toString();
                                          verse = await Provider.of<
                                                      VerseProvider>(context,
                                                  listen: false)
                                              .getVerses(
                                                  bookNo: books.bookNo!,
                                                  chapterNo:
                                                      int.parse(selected_book),
                                                  context: context);
                                          selected_verse =
                                              Provider.of<VerseProvider>(
                                                      context,
                                                      listen: false)
                                                  .verse
                                                  .first;
                                          setState(() {});
                                        },
                                      ),
                                      DropdownButton<VerseModel>(
                                        value: selected_verse,
                                        items: verse.map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.verseNo.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          selected_verse = val!;
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VersePage(
                                                      book: BooksModel(
                                                          bookNo: selected_verse
                                                              .book,
                                                          name: getBookName(
                                                              selected_verse
                                                                  .book!),
                                                          noOfBooks: bibleBooks[
                                                              getBookName(
                                                                  selected_verse
                                                                      .book!)]),
                                                      chapter: selected_verse
                                                          .chapter!,
                                                      verseNo: selected_verse
                                                          .verseNo,
                                                    )));
                                      },
                                      child: Text(gotoVerse))
                                ],
                              ),
                            );
                          }));
                },
                title: referece,
              ),
              HomeTile(
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                title: searchName,
              ),
              HomeTile(
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookMarks()));
                },
                title: bookmarkName,
              ),
              HomeTile(
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                title: settingsName,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecentlyViewVersePage()));
        },
        child: Icon(Icons.history),
      ),
    );
  }
}

class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.title,
    required this.ontap,
  });
  final String title;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .15,
        width: MediaQuery.of(context).size.height * .15,
        child: Card(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
