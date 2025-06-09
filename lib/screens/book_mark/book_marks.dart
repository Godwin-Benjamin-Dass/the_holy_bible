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
    return Scaffold(
      appBar: AppBar(title: Text(bookmarkName), actions: [
        IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: false,
                builder: (BuildContext context) {
                  return Consumer<ThemeProvider>(
                    builder: (context, theme, child) => SizedBox(
                      height: 200,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  fontsSize,
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
                                      darkTheme,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Spacer(),
                                    Switch(
                                        value: theme.isDarkMode,
                                        onChanged: ((val) {
                                          theme.toggleTheme();
                                        }))
                                  ],
                                )
                              ],
                            ),
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
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
            },
            icon: const Icon(Icons.home))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: bookMarks.isEmpty
            ? Center(
                child: Text(
                  noBookMarksYet,
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
                          title: Text(howCanIhelpYou),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                          text:
                                              "${vm.verse!} ${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}"))
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text(copy),
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
                                                    name: getBookName(vm.book!),
                                                    noOfBooks: bibleBooks[
                                                        getBookName(vm.book!)]),
                                                chapter: vm.chapter!,
                                                verseNo: vm.verseNo,
                                              )));
                                },
                                child: Text(gotoVerse),
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
                                child: Text(remove),
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
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                vm.verse!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(bookMarks[i]["time"]
                                .toString()
                                .substring(00, 10)),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
