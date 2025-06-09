// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/models/verse_model.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:holy_bible_tamil/screens/bible/chapters_page.dart';
import 'package:holy_bible_tamil/screens/home_flow/home_page.dart';
import 'package:holy_bible_tamil/service.dart/book_mark_service.dart';
import 'package:holy_bible_tamil/service.dart/continue_reading_service.dart';
import 'package:holy_bible_tamil/widgets/drawer_list.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../provider/books_provider.dart';

bool isFirstTime = true;

class VersePage extends StatefulWidget {
  const VersePage(
      {super.key,
      required this.book,
      required this.chapter,
      this.verseNo,
      this.isFromHome = false});
  final BooksModel book;
  final int chapter;
  final int? verseNo;
  final bool isFromHome;

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  @override
  void initState() {
    super.initState();
    getVerse();
  }

  getVerse() async {
    chapter = widget.chapter;
    Future.delayed(isFirstTime ? Duration(seconds: 1) : Duration.zero,
        () async {
      await Provider.of<VerseProvider>(context, listen: false).getVerses(
          bookNo: widget.book.bookNo!,
          chapterNo: widget.chapter,
          context: context);
      isFirstTime = false;
    }).then((val) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToItem();
      });

      await ContinueReadingService.setData(
          book: widget.book,
          chapter: chapter,
          verse: widget.verseNo,
          context: context);
      for (var vm in Provider.of<VerseProvider>(context, listen: false).verse) {
        vm.isSelected = false;
      }
      copyVerse.clear();
      setState(() {});
    });
  }

  _scrollToItem() {
    if (widget.verseNo != null) {
      _scrollController.scrollTo(
          index: widget.verseNo! - 1,
          duration: const Duration(milliseconds: 800));
    }
  }

  nextChapter() async {
    if (chapter + 1 <= widget.book.noOfBooks!) {
      chapter++;
      Provider.of<VerseProvider>(context, listen: false).getVerses(
          bookNo: widget.book.bookNo!, chapterNo: chapter, context: context);
      setState(() {});
      await ContinueReadingService.setData(book: widget.book, chapter: chapter);
      _scrollController.scrollTo(
          index: 0, duration: const Duration(milliseconds: 800));
      for (var vm in Provider.of<VerseProvider>(context, listen: false).verse) {
        vm.isSelected = false;
      }
      copyVerse.clear();
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: ended);
    }
  }

  previousChapter() async {
    if (chapter - 1 != 0) {
      chapter--;
      Provider.of<VerseProvider>(context, listen: false).getVerses(
          bookNo: widget.book.bookNo!, chapterNo: chapter, context: context);
      setState(() {});
      await ContinueReadingService.setData(book: widget.book, chapter: chapter);
      _scrollController.scrollTo(
          index: 0, duration: const Duration(milliseconds: 800));
      for (var vm in Provider.of<VerseProvider>(context, listen: false).verse) {
        vm.isSelected = false;
      }
      copyVerse.clear();
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: ended);
    }
  }

  int chapter = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ItemScrollController _scrollController = ItemScrollController();
  List<VerseModel> copyVerse = [];
  double _baseScaleFactor = 1.0;
  Future<bool> _willPopCallback() async {
    if (copyVerse.isNotEmpty) {
      copyVerse.clear();
      for (var vm in Provider.of<VerseProvider>(context, listen: false).verse) {
        vm.isSelected = false;
      }
      setState(() {});
      return false;
    }
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => _key.currentState!.openDrawer(),
            icon: const Icon(
              Icons.menu,
              size: 30,
            )),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
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
        ],
        title: Text(widget.book.name!),
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 100),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      previousChapter();
                    },
                    heroTag: "btn1",
                    child: const Icon(Icons.arrow_back),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChaptersPage(
                                    book: widget.book,
                                  )));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              chapterName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              chapter.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                _scrollController.scrollTo(
                                    index: int.parse(value),
                                    duration:
                                        const Duration(milliseconds: 800));
                              },
                              child: Container(
                                height: 30,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white),
                                alignment: Alignment.center,
                                child: Text(
                                  "Verse",
                                  style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context,
                                                  listen: false)
                                              .isDarkMode
                                          ? Colors.black
                                          : null,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              itemBuilder: (BuildContext context) =>
                                  List.generate(
                                      Provider.of<VerseProvider>(context,
                                              listen: false)
                                          .verse
                                          .length, (index) {
                                return PopupMenuItem<String>(
                                  value: index.toString(),
                                  child: Text((index + 1).toString()),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      nextChapter();
                    },
                    heroTag: "btn2",
                    child: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
            )),
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: _willPopCallback,
        child: Consumer<VerseProvider>(
          builder: (context, verse, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              itemCount: verse.verse.length,
              itemBuilder: (context, i) {
                VerseModel vm = verse.verse[i];
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
                    vm.isSelected = !vm.isSelected!;
                    if (vm.isSelected!) {
                      copyVerse.add(vm);
                    } else {
                      copyVerse.remove(vm);
                    }
                    setState(() {});
                  },
                  onLongPress: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        // title: Text(howCanIhelpYou),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(
                                        text:
                                            "${vm.verse!} ${widget.book.name} ${vm.chapter!}:${vm.verseNo!}"))
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
                                BookMarkService.addBookMark(vm).then((value) {
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(addToBookMark),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(close),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                      child: ListTile(
                        title: Text(
                          vm.verseNo.toString() + ") " + vm.verse!,
                          style: TextStyle(
                              color: vm.isSelected! ? Colors.orange : null,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Consumer<BooksProvider>(
            builder: (context, book, child) => SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            theOldTestamentName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        DrawerList(
                            isFromHome: widget.isFromHome,
                            books: book.oldTestament),
                        Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            theNewTestamentName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        DrawerList(
                            isFromHome: widget.isFromHome,
                            books: book.newTestament)
                      ],
                    ),
                  ),
                )),
      ),
      floatingActionButton: copyVerse.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                    heroTag: "btn_3",
                    onPressed: () async {
                      String copyString = "";
                      for (var vm in copyVerse) {
                        copyString += "${vm.verseNo!} ${vm.verse}";
                        copyString += "\n";
                      }
                      copyString +=
                          "${widget.book.name}:${copyVerse.first.chapter!}";
                      await Clipboard.setData(ClipboardData(text: copyString));
                      copyVerse.clear();
                      for (var vm
                          in Provider.of<VerseProvider>(context, listen: false)
                              .verse) {
                        vm.isSelected = false;
                      }
                      setState(() {});
                    },
                    child: const Icon(Icons.copy)),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                    heroTag: "btn_4",
                    onPressed: () async {
                      for (var vm in copyVerse) {
                        await BookMarkService.addBookMark(vm);
                      }
                      for (var vm
                          in Provider.of<VerseProvider>(context, listen: false)
                              .verse) {
                        vm.isSelected = false;
                      }
                      copyVerse.clear();
                      Fluttertoast.showToast(msg: addToBookmark);
                      setState(() {});
                    },
                    child: const Icon(Icons.book))
              ],
            )
          : null,
    );
  }
}
