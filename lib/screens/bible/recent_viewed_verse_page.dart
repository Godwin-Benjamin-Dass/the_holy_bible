import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:provider/provider.dart';

class RecentlyViewVersePage extends StatelessWidget {
  const RecentlyViewVersePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          theme.recentVerse,
          maxFontSize: 16,
          minFontSize: 13,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 2,
      ),
      body: Consumer<VerseProvider>(
        builder: (context, verse, child) {
          final recentlyViewed = verse.recentlyViewedVerse.reversed.toList();

          if (recentlyViewed.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: recentlyViewed.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              BooksModel book = recentlyViewed[i]["book"];
              int chapter = recentlyViewed[i]["chapter"];
              int verseNo = recentlyViewed[i]["verse"];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VersePage(
                        book: book,
                        chapter: chapter,
                        verseNo: verseNo,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: const Icon(Icons.menu_book_rounded,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                theme.format == 'onlyTamil'
                                    ? book.nameT ?? ""
                                    : theme.format == 'onlyEnglish'
                                        ? book.nameE ?? ""
                                        : theme.format == 'tamilEnglish'
                                            ? (book.nameT ?? '') +
                                                '/' +
                                                (book.nameE ?? '')
                                            : (book.nameE ?? '') +
                                                '/' +
                                                (book.nameT ?? ''),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Chapter $chapter • Verse $verseNo",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Colors.grey, size: 28),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// UI shown when no recent verses are found
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded,
                size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 20),
            const Text(
              "No recently viewed verses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "Start reading and your history will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
