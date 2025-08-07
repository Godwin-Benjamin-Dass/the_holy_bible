// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/provider/books_provider.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:holy_bible_tamil/screens/bible/book_page.dart';
import 'package:holy_bible_tamil/screens/bible/recent_viewed_verse_page.dart';
import 'package:holy_bible_tamil/screens/bible/search_page.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:holy_bible_tamil/screens/book_mark/book_marks.dart';
import 'package:holy_bible_tamil/screens/home_flow/settings_page.dart';
import 'package:holy_bible_tamil/screens/notes_flow/notes_home_page.dart';
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
      body: Consumer<ThemeProvider>(
        builder: (context, theme, child) => Center(
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
                  title: theme.holyBibeName,
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
                      title: theme.oldTestamentName,
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
                                          nameT: "ஆதியாகமம்",
                                          nameE: "Genesis"),
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
                      title: theme.continueReadingName,
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
                      title: theme.newTestamentName,
                    ),
                  ],
                ),
                HomeTile(
                  ontap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotesHomePage()));
                  },
                  title: theme.takeNotes,
                ),
                HomeTile(
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()));
                  },
                  title: theme.searchName,
                ),
                HomeTile(
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookMarks()));
                  },
                  title: theme.bookmarkName,
                ),
                HomeTile(
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  },
                  title: theme.settingsName,
                ),
              ],
            ),
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
            child: AutoSizeText(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxFontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
