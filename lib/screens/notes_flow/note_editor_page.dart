// pages/note_editor_page.dart
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/models/verse_model.dart';
import 'package:holy_bible_tamil/provider/books_provider.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:holy_bible_tamil/service.dart/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NoteEditorPage extends StatefulWidget {
  final Map<String, dynamic>? note;
  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isEditing = false;
  Timer? _debounce;
  bool _showSaved = false; // For "Saved" indicator

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      isEditing = true;
      _titleController.text = widget.note!['title'] ?? '';
      _contentController.text = widget.note!['content'] ?? '';
    }

    // Auto-save listeners
    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), _autoSave);
  }

  Future<void> _autoSave() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    String date = DateFormat.yMMMMd().format(DateTime.now());

    if (isEditing) {
      await DBHelper.updateNote(widget.note!['id'], title, content);
    } else {
      int newId = await DBHelper.insertNote(title, content, date);
      widget.note?['id'] = newId;
      isEditing = true;
    }

    // Show saved indicator
    setState(() => _showSaved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSaved = false);
    });

    debugPrint("Note auto-saved ✅");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: SafeArea(
          child: Row(
            children: [
              const BackButton(),
              Expanded(
                child: AutoSizeText(
                  isEditing ? theme.editNotes : theme.newNotes,
                  maxFontSize: 17,
                  minFontSize: 17,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (_showSaved)
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    "Saved",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green),
                  ),
                ),
              IconButton(
                tooltip: "Share",
                onPressed: () {
                  String title = _titleController.text.trim();
                  String content = _contentController.text.trim();
                  if (title.isEmpty && content.isEmpty) return;
                  Share.share("$title\n\n$content");
                },
                icon: const Icon(Icons.share),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Type your note here...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Existing verse reference picker (untouched)
          BooksModel books = Provider.of<BooksProvider>(context, listen: false)
              .oldTestament
              .first;
          List chapters = List.generate(50, (i) => i + 1);
          String selected_book = "1";
          List<VerseModel> verse =
              await Provider.of<VerseProvider>(context, listen: false)
                  .getVerses(bookNo: 1, chapterNo: 1, context: context);
          VerseModel selected_verse =
              Provider.of<VerseProvider>(context, listen: false).verse.first;
          List<BooksModel> book =
              Provider.of<BooksProvider>(context, listen: false).oldTestament +
                  Provider.of<BooksProvider>(context, listen: false)
                      .newTestament;

          showDialog(
            context: context,
            builder: (_) => StatefulBuilder(
              builder: (context, setState) {
                return Consumer<ThemeProvider>(
                  builder: (context, theme, child) => AlertDialog(
                    title: Text(theme.referece),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton(
                          value: books,
                          items: book.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(getFormattedBookName(theme, value)),
                            );
                          }).toList(),
                          onChanged: (val) async {
                            books = val!;
                            selected_book = "1";
                            verse = await Provider.of<VerseProvider>(context,
                                    listen: false)
                                .getVerses(
                                    bookNo: books.bookNo!,
                                    chapterNo: 1,
                                    context: context);
                            selected_verse = Provider.of<VerseProvider>(context,
                                    listen: false)
                                .verse
                                .first;
                            chapters =
                                List.generate(books.noOfBooks!, (i) => i + 1);
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                selected_book = val!;
                                verse = await Provider.of<VerseProvider>(
                                        context,
                                        listen: false)
                                    .getVerses(
                                        bookNo: books.bookNo!,
                                        chapterNo: int.parse(selected_book),
                                        context: context);
                                selected_verse = Provider.of<VerseProvider>(
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
                                  child: Text(value.verseNo.toString()),
                                );
                              }).toList(),
                              onChanged: (val) {
                                selected_verse = val!;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            String? verses = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VersePage(
                                  isFromnotes: true,
                                  book: BooksModel(
                                    bookNo: selected_verse.book,
                                    nameE: getBookNameEng(selected_verse.book!),
                                    nameT: getBookName(selected_verse.book!),
                                    noOfBooks: bibleBooks[
                                        getBookName(selected_verse.book!)],
                                  ),
                                  chapter: selected_verse.chapter!,
                                  verseNo: selected_verse.verseNo,
                                ),
                              ),
                            );
                            if (verses != null) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text(theme.gotoVerse),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String getFormattedBookName(ThemeProvider theme, BooksModel book) {
    switch (theme.format) {
      case 'onlyTamil':
        return book.nameT!;
      case 'onlyEnglish':
        return book.nameE!;
      case 'tamilEnglish':
        return '${book.nameT!} / ${book.nameE!}';
      case 'englishTamil':
        return '${book.nameE!} / ${book.nameT!}';
      default:
        return book.nameE!;
    }
  }
}
