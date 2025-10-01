import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/models/verse_model.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:holy_bible_tamil/screens/home_flow/home_page.dart';
import 'package:holy_bible_tamil/screens/notes_flow/note_editor_page.dart';
import 'package:holy_bible_tamil/service.dart/book_mark_service.dart';
import 'package:holy_bible_tamil/service.dart/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookMarks extends StatefulWidget {
  const BookMarks({super.key});

  @override
  State<BookMarks> createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  List bookMarks = [];
  double _baseScaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    bookMarks = await BookMarkService.getList();
    bookMarks = bookMarks.reversed.toList();
    setState(() {});
  }

  Map<String, List<Map<String, dynamic>>> groupedNotes = {};
  Future<void> _loadNotes() async {
    final notes = await DBHelper.getNotes();
    groupedNotes.clear();
    for (var note in notes) {
      String date = note['date'];
      groupedNotes.putIfAbsent(date, () => []).add(note);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) => Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 70),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      BackButton(),
                      Tooltip(
                          message: theme.bookmarkName,
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * .6,
                            child: AutoSizeText(
                              theme.bookmarkName,
                              maxFontSize: 17,
                              minFontSize: 17,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        tooltip: "Settings",
                        onPressed: () => _showSettingsSheet(context, theme),
                      ),
                      IconButton(
                        icon: const Icon(Icons.home),
                        tooltip: "Home",
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: bookMarks.isEmpty
              ? Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            theme.noBookMarksYet,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: bookMarks.length,
                  itemBuilder: (ctx, i) {
                    VerseModel vm = VerseModel.fromJson(bookMarks[i]["verse"]);
                    String time =
                        bookMarks[i]["time"].toString().substring(0, 10);

                    return GestureDetector(
                      onScaleStart: (details) {
                        _baseScaleFactor = theme.fontSize;
                      },
                      onScaleUpdate: (details) {
                        theme.setFontSize(_baseScaleFactor * details.scale);
                      },
                      onTap: () => _showVerseOptions(context, vm, theme),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: theme.format == 'tamilEnglish'
                              ? tamilEnglishMethod(vm, time)
                              : theme.format == 'englishTamil'
                                  ? englishTamilMethod(vm, time)
                                  : theme.format == 'onlyTamil'
                                      ? onlyTamilMethod(vm, time)
                                      : onlyEnglishMethod(vm, time),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  /// SETTINGS SHEET
  void _showSettingsSheet(BuildContext context, ThemeProvider theme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(theme.fontsSize,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: theme.fontSize)),
            SfSlider(
              min: 10,
              max: 30,
              value: theme.fontSize,
              interval: 5,
              showTicks: true,
              showLabels: true,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (val) => theme.setFontSize(val),
            ),
            SwitchListTile(
              title: Text(theme.darkTheme),
              value: theme.isDarkMode,
              onChanged: (_) => theme.toggleTheme(),
              secondary: const Icon(Icons.dark_mode),
            ),
            const Divider(),
            Text("Select Format",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: theme.fontSize)),
            _formatOption(theme, "Tamil followed by English", "tamilEnglish"),
            _formatOption(theme, "English followed by Tamil", "englishTamil"),
            _formatOption(theme, "Only Tamil", "onlyTamil"),
            _formatOption(theme, "Only English", "onlyEnglish"),
          ],
        ),
      ),
    );
  }

  Widget _formatOption(ThemeProvider theme, String label, String value) {
    return RadioListTile(
      value: value,
      groupValue: theme.format,
      onChanged: (val) => theme.setFormat(val!),
      title: Text(label),
    );
  }

  /// VERSE ACTION DIALOG
  void _showVerseOptions(
      BuildContext context, VerseModel vm, ThemeProvider theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(theme.howCanIhelpYou),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(theme.copy),
              onTap: () async {
                await _copyVerse(vm, theme);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(theme.gotoVerse),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VersePage(
                      book: BooksModel(
                        bookNo: vm.book,
                        nameT: getBookName(vm.book!),
                        nameE: getBookNameEng(vm.book!),
                        noOfBooks: bibleBooks[getBookName(vm.book!)],
                      ),
                      chapter: vm.chapter!,
                      verseNo: vm.verseNo,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(theme.remove),
              onTap: () async {
                await BookMarkService.removeBookMark(vm).then((_) {
                  getData();
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(theme.AddToNotes),
              onTap: () async {
                String verseString = '';
                if (theme.format == 'tamilEnglish') {
                  verseString =
                      '${vm.verseTam}\n ${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!} \n\n ${vm.verseEng}\n ${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!} ';
                } else if (theme.format == 'englishTamil') {
                  verseString =
                      '${vm.verseEng}\n ${getBookNameEng(vm.book!)}\n ${vm.chapter}\n ${vm.verseNo}\n\n ${vm.verseTam}\n ${getBookName(vm.book!)}\n ${vm.chapter}\n ${vm.verseNo}';
                } else if (theme.format == 'onlyTamil') {
                  verseString =
                      '${vm.verseTam}\n ${getBookName(vm.book!)}\n ${vm.chapter}\n ${vm.verseNo}';
                } else if (theme.format == 'onlyEnglish') {
                  verseString =
                      '${vm.verseEng}\n ${getBookNameEng(vm.book!)}\n ${vm.chapter}\n ${vm.verseNo}';
                }
                await _loadNotes();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(theme.AddToNotes),
                                  Spacer(),
                                  if (groupedNotes.isNotEmpty)
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => NoteEditorPage(
                                                verseFromOtherPage: verseString,
                                              ),
                                            ),
                                          ).then((val) {
                                            for (var vm
                                                in Provider.of<VerseProvider>(
                                                        context,
                                                        listen: false)
                                                    .verse) {
                                              vm.isSelected = false;
                                            }
                                            setState(() {});
                                            Navigator.pop(context);
                                          });
                                        },
                                        icon: Icon(Icons.add))
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .5,
                                width: MediaQuery.of(context).size.width * .7,
                                child: groupedNotes.isEmpty
                                    ? Center(
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      NoteEditorPage(
                                                    verseFromOtherPage:
                                                        verseString,
                                                  ),
                                                ),
                                              ).then((val) {
                                                for (var vm in Provider.of<
                                                            VerseProvider>(
                                                        context,
                                                        listen: false)
                                                    .verse) {
                                                  vm.isSelected = false;
                                                }
                                                setState(() {});
                                                Navigator.pop(context);
                                              });
                                            },
                                            icon: Icon(Icons.add)),
                                      )
                                    : ListView(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(12.0),
                                        children:
                                            groupedNotes.entries.map((entry) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 4),
                                                child: Text(
                                                  entry.key, // Date
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              ...entry.value.map((note) {
                                                return Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  elevation: 3,
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 6),
                                                  child: ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    title: Text(
                                                      note['title'].isEmpty
                                                          ? "(Untitled)"
                                                          : note['title'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    subtitle: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: Text(
                                                        note['content'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                NoteEditorPage(
                                                                    verseFromOtherPage:
                                                                        verseString,
                                                                    note:
                                                                        note)),
                                                      ).then((val) {
                                                        for (var vm in Provider
                                                                .of<VerseProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                            .verse) {
                                                          vm.isSelected = false;
                                                        }
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                              ),
                              TextButton(
                                child: Text(theme.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// COPY VERSE
  Future<void> _copyVerse(VerseModel vm, ThemeProvider theme) async {
    var format = theme.format;
    String text = "";
    if (format == 'onlyTamil') {
      text =
          "${vm.verseTam!} ${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}";
    } else if (format == 'onlyEnglish') {
      text =
          "${vm.verseEng!} ${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}";
    } else if (format == 'tamilEnglish') {
      text =
          "${vm.verseTam!} ${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}\n${vm.verseEng!} ${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}";
    } else if (format == 'englishTamil') {
      text =
          "${vm.verseEng!} ${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}\n${vm.verseTam!} ${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}";
    }
    await Clipboard.setData(ClipboardData(text: text));
  }

  // VERSE DISPLAY METHODS
  Column onlyTamilMethod(VerseModel vm, String time) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vm.verseTam ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Provider.of<ThemeProvider>(context).fontSize)),
          const SizedBox(height: 6),
          Text("${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      );

  Column onlyEnglishMethod(VerseModel vm, String time) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vm.verseEng ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Provider.of<ThemeProvider>(context).fontSize)),
          const SizedBox(height: 6),
          Text("${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      );

  Column tamilEnglishMethod(VerseModel vm, String time) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vm.verseTam ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Provider.of<ThemeProvider>(context).fontSize)),
          const SizedBox(height: 6),
          Text("${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Divider(),
          Text(vm.verseEng ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Provider.of<ThemeProvider>(context).fontSize)),
          const SizedBox(height: 6),
          Text("${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      );

  Column englishTamilMethod(VerseModel vm, String time) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vm.verseEng ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Provider.of<ThemeProvider>(context).fontSize)),
          const SizedBox(height: 6),
          Text("${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Divider(),
          Text(vm.verseTam ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Provider.of<ThemeProvider>(context).fontSize)),
          const SizedBox(height: 6),
          Text("${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      );
}
