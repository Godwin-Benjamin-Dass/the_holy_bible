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
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: AutoSizeText(
            '📖 ${theme.holyBibeName}',
            maxFontSize: 15,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _homeTile(
                context,
                theme.oldTestamentName,
                Icons.menu_book_rounded,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const BooksPage())),
              ),
              _homeTile(
                context,
                theme.newTestamentName,
                Icons.menu_book,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const BooksPage(idx: 1))),
              ),
              _homeTile(
                context,
                theme.continueReadingName,
                Icons.play_arrow_rounded,
                () async {
                  var data = await ContinueReadingService.getData();
                  if (data == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VersePage(
                                  isFromHome: true,
                                  book: BooksModel(
                                    bookNo: 1,
                                    noOfBooks: 50,
                                    nameT: "ஆதியாகமம்",
                                    nameE: "Genesis",
                                  ),
                                  chapter: 1,
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VersePage(
                                  isFromHome: true,
                                  book: data["book"],
                                  chapter: data["chapter"],
                                  verseNo: data["verse"],
                                )));
                  }
                },
              ),
              _homeTile(
                context,
                theme.takeNotes,
                Icons.note_alt_rounded,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => NotesHomePage())),
              ),
              _homeTile(
                context,
                theme.searchName,
                Icons.search_rounded,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchPage())),
              ),
              _homeTile(
                context,
                theme.bookmarkName,
                Icons.bookmark_rounded,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const BookMarks())),
              ),
              _homeTile(
                context,
                theme.settingsName,
                Icons.settings_rounded,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsPage())),
              ),
              _homeTile(
                context,
                'History',
                Icons.history_rounded,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RecentlyViewVersePage())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeTile(
      BuildContext context, String title, IconData icon, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              AutoSizeText(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
