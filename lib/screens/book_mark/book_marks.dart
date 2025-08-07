import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/models/verse_model.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:holy_bible_tamil/screens/home_flow/home_page.dart';
import 'package:holy_bible_tamil/service.dart/book_mark_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookMarks extends StatefulWidget {
  const BookMarks({super.key});

  @override
  State<BookMarks> createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  List bookMarks = [];

  getData() async {
    bookMarks = await BookMarkService.getList();
    bookMarks = bookMarks.reversed.toList();
    setState(() {});
  }

  double _baseScaleFactor = 1.0;

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
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: false,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              theme.fontsSize,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: theme.fontSize),
                                            ),
                                            SfSlider(
                                                min: 10,
                                                max: 30,
                                                value: theme.fontSize,
                                                onChanged: ((val) {
                                                  theme.setFontSize(val);
                                                })),
                                            Row(
                                              children: [
                                                Text(
                                                  theme.darkTheme,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                const Spacer(),
                                                Switch(
                                                    value: theme.isDarkMode,
                                                    onChanged: ((val) {
                                                      theme.toggleTheme();
                                                    }))
                                              ],
                                            ),
                                            Text(
                                              'Select format',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: theme.fontSize),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                theme.setFormat('tamilEnglish');
                                              },
                                              leading: Radio(
                                                  value: 'tamilEnglish',
                                                  groupValue: theme.format,
                                                  onChanged: (val) {
                                                    theme.setFormat(val!);
                                                  }),
                                              title: Text(
                                                'Tamil followed by English',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                theme.setFormat('englishTamil');
                                              },
                                              leading: Radio(
                                                  value: 'englishTamil',
                                                  groupValue: theme.format,
                                                  onChanged: (val) {
                                                    theme.setFormat(val!);
                                                  }),
                                              title: Text(
                                                'English followed by Tamil',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                theme.setFormat('onlyTamil');
                                              },
                                              leading: Radio(
                                                  value: 'onlyTamil',
                                                  groupValue: theme.format,
                                                  onChanged: (val) {
                                                    theme.setFormat(val!);
                                                  }),
                                              title: Text(
                                                'Only Tamil',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                theme.setFormat('onlyEnglish');
                                              },
                                              leading: Radio(
                                                  value: 'onlyEnglish',
                                                  groupValue: theme.format,
                                                  onChanged: (val) {
                                                    theme.setFormat(val!);
                                                  }),
                                              title: Text(
                                                'Only English',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.settings)),
                      IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (route) => false);
                          },
                          icon: const Icon(Icons.home))
                    ],
                  ),
                ],
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: bookMarks.isEmpty
              ? Center(
                  child: Text(
                    theme.noBookMarksYet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                )
              : ListView.builder(
                  itemCount: bookMarks.length,
                  itemBuilder: (ctx, i) {
                    VerseModel vm = VerseModel.fromJson(bookMarks[i]["verse"]);
                    return GestureDetector(
                      onScaleStart: (details) {
                        _baseScaleFactor =
                            Provider.of<ThemeProvider>(context, listen: false)
                                .fontSize;
                      },
                      onScaleUpdate: (details) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .setFontSize(_baseScaleFactor * details.scale);
                      },
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(theme.howCanIhelpYou),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    var format = Provider.of<ThemeProvider>(
                                            context,
                                            listen: false)
                                        .format;
                                    if (format == 'onlyTamil') {
                                      await Clipboard.setData(ClipboardData(
                                              text:
                                                  "${vm.verseTam!} ${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}"))
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    }
                                    if (format == 'onlyEnglish') {
                                      await Clipboard.setData(ClipboardData(
                                              text:
                                                  "${vm.verseEng!} ${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}"))
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    }
                                    if (format == 'tamilEnglish') {
                                      await Clipboard.setData(ClipboardData(
                                              text:
                                                  "${vm.verseTam!} ${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!} \n${vm.verseEng!} ${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}"))
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    }
                                    if (format == 'englishTamil') {
                                      await Clipboard.setData(ClipboardData(
                                              text:
                                                  "${vm.verseEng!} ${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!} \n${vm.verseTam!} ${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!} \n"))
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                  child: Text(theme.copy),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VersePage(
                                                  book: BooksModel(
                                                      bookNo: vm.book,
                                                      nameT:
                                                          getBookName(vm.book!),
                                                      nameE: getBookNameEng(
                                                          vm.book!),
                                                      noOfBooks: bibleBooks[
                                                          getBookName(
                                                              vm.book!)]),
                                                  chapter: vm.chapter!,
                                                  verseNo: vm.verseNo,
                                                )));
                                  },
                                  child: Text(theme.gotoVerse),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await BookMarkService.removeBookMark(vm)
                                        .then((value) {
                                      getData();
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text(theme.remove),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          child: Consumer<ThemeProvider>(
                              builder: (context, theme, child) =>
                                  theme.format == 'tamilEnglish'
                                      ? tamilEnglishMethod(
                                          vm,
                                          bookMarks[i]["time"]
                                              .toString()
                                              .substring(00, 10))
                                      : theme.format == 'englishTamil'
                                          ? EnglishTamilMethod(
                                              vm,
                                              bookMarks[i]["time"]
                                                  .toString()
                                                  .substring(00, 10))
                                          : theme.format == 'onlyTamil'
                                              ? onlyTamilMethod(
                                                  vm,
                                                  bookMarks[i]["time"]
                                                      .toString()
                                                      .substring(00, 10))
                                              : onlyEnglishMethod(
                                                  vm,
                                                  bookMarks[i]["time"]
                                                      .toString()
                                                      .substring(00, 10))),
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }

  Column onlyTamilMethod(VerseModel vm, time) {
    return Column(
      children: [
        ListTile(
          title: Text(
            vm.verseTam ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(time),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Column onlyEnglishMethod(VerseModel vm, time) {
    return Column(
      children: [
        ListTile(
          title: Text(
            vm.verseEng ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(time),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Column tamilEnglishMethod(VerseModel vm, time) {
    return Column(
      children: [
        ListTile(
          title: Text(
            vm.verseTam ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Divider(),
        ListTile(
          title: Text(
            vm.verseEng ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(time),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Column EnglishTamilMethod(VerseModel vm, time) {
    return Column(
      children: [
        ListTile(
          title: Text(
            vm.verseEng ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Divider(),
        ListTile(
          title: Text(
            vm.verseTam ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(time),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
