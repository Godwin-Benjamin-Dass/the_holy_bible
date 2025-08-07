// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:holy_bible_tamil/widgets/swipeable_verse_card.dart';
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
      this.isFromnotes = false,
      this.isFromHome = false});
  final BooksModel book;
  final int chapter;
  final int? verseNo;
  final bool isFromHome;
  final bool isFromnotes;

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  int? _previousFirstIndex;
  @override
  void initState() {
    super.initState();
    getVerse();
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;

      if (positions.isNotEmpty) {
        final firstVisibleItemIndex = positions
            .where((item) => item.itemLeadingEdge >= 0)
            .map((e) => e.index)
            .reduce((a, b) => a < b ? a : b);

        if (_previousFirstIndex != null) {
          if (firstVisibleItemIndex > _previousFirstIndex!) {
            onScrollDown();
          } else if (firstVisibleItemIndex < _previousFirstIndex!) {
            onScrollUp();
          }
        }

        _previousFirstIndex = firstVisibleItemIndex;
      }
    });
  }

  bool showAppBar = true;
  bool oldTest = false;
  bool newTest = false;

  void onScrollUp() {
    print("User scrolled UP");
    if (!showAppBar) {
      setState(() {
        showAppBar = true;
      });
    }
    // Add your logic here
  }

  void onScrollDown() {
    print("User scrolled DOWN");
    if (showAppBar) {
      setState(() {
        showAppBar = false;
      });
    }
    // Add your logic here
  }

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  getVerse() async {
    chapter = widget.chapter;
    Future.delayed(Duration.zero, () async {
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

      await ContinueReadingService.setData(
          book: widget.book, chapter: chapter, context: context);
      _scrollController.scrollTo(
          index: 0, duration: const Duration(milliseconds: 800));
      for (var vm in Provider.of<VerseProvider>(context, listen: false).verse) {
        vm.isSelected = false;
      }
      copyVerse.clear();
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: Provider.of<ThemeProvider>(context, listen: false).ended);
    }
  }

  previousChapter() async {
    if (chapter - 1 != 0) {
      chapter--;
      Provider.of<VerseProvider>(context, listen: false).getVerses(
          bookNo: widget.book.bookNo!, chapterNo: chapter, context: context);
      setState(() {});
      await ContinueReadingService.setData(
          book: widget.book, chapter: chapter, context: context);
      _scrollController.scrollTo(
          index: 0, duration: const Duration(milliseconds: 800));
      for (var vm in Provider.of<VerseProvider>(context, listen: false).verse) {
        vm.isSelected = false;
      }
      copyVerse.clear();
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: Provider.of<ThemeProvider>(context, listen: false).ended);
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Fade + Slide transition
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -0.2),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: showAppBar
              ? buildCustomAppBar(context, _key, widget.book)
              : const SizedBox.shrink(key: ValueKey('empty-appbar')),
        ),
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: _willPopCallback,
        child: SafeArea(
          child: Consumer<VerseProvider>(
            builder: (context, verse, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SwipeableVerseCard(
                onSwipeLeft: () => nextChapter(),
                onSwipeRight: () => previousChapter(),
                child: ScrollablePositionedList.builder(
                  itemPositionsListener: itemPositionsListener,
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
                            content: Consumer<ThemeProvider>(
                              builder: (context, theme, child) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await Clipboard.setData(ClipboardData(
                                              text:
                                                  "${vm.verseTam!} ${widget.book.nameT} ${vm.chapter!}:${vm.verseNo!}"))
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text(theme.copy),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      BookMarkService.addBookMark(vm)
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text(theme.addToBookMark),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(theme.close),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Consumer<ThemeProvider>(
                        builder: (context, theme, child) => Card(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Provider.of<ThemeProvider>(context,
                                                listen: false)
                                            .isDarkMode
                                        ? Colors.white
                                        : Colors.black)),
                            child: theme.format == 'onlyTamil'
                                ? onlyTamilWidget(vm)
                                : theme.format == 'onlyEnglish'
                                    ? onlyEnglishWidget(vm)
                                    : theme.format == 'tamilEnglish'
                                        ? tamilFollowedByEnglishWidget(vm)
                                        : englishFollowedByEnglishWidget(vm),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),

      drawer: (widget.isFromnotes)
          ? null
          : Drawer(
              child: Consumer<BooksProvider>(
                  builder: (context, book, child) => SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  oldTest = !oldTest;
                                  setState(() {});
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Text(
                                        '  ' +
                                            Provider.of<ThemeProvider>(context,
                                                    listen: true)
                                                .theOldTestamentName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      RotatedBox(
                                        quarterTurns: oldTest ? 1 : 0,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if (oldTest)
                                DrawerList(
                                    isOldTestament: true,
                                    isFromHome: widget.isFromHome,
                                    books: book.oldTestament),
                              InkWell(
                                onTap: () {
                                  newTest = !newTest;
                                  setState(() {});
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Text(
                                        '  ' +
                                            Provider.of<ThemeProvider>(context,
                                                    listen: true)
                                                .theNewTestamentName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      RotatedBox(
                                        quarterTurns: newTest ? 1 : 0,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if (newTest)
                                DrawerList(
                                    isFromHome: widget.isFromHome,
                                    books: book.newTestament)
                            ],
                          ),
                        ),
                      )),
            ),
      floatingActionButton: widget.isFromnotes
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "5",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close),
                ),
                SizedBox(
                  height: 10,
                ),
                if (copyVerse.isNotEmpty)
                  Consumer<ThemeProvider>(
                    builder: (context, theme, child) => FloatingActionButton(
                      heroTag: "6",
                      onPressed: () async {
                        String copyString = "";
                        if (theme.format == 'onlyTamil') {
                          for (var vm in copyVerse) {
                            copyString += "${vm.verseNo!} ${vm.verseTam}";
                            copyString += "\n";
                          }
                          copyString +=
                              "${widget.book.nameT}:${copyVerse.first.chapter!}";
                        }
                        if (theme.format == 'onlyEnglish') {
                          for (var vm in copyVerse) {
                            copyString += "${vm.verseNo!} ${vm.verseEng}";
                            copyString += "\n";
                          }
                          copyString +=
                              "${getBookNameEng(widget.book.bookNo!)}:${copyVerse.first.chapter!}";
                        }
                        if (theme.format == 'tamilEnglish') {
                          for (var vm in copyVerse) {
                            copyString += "${vm.verseNo!} ${vm.verseTam}";
                            copyString += "\n";
                            copyString += "${vm.verseEng}";
                            copyString += "\n";
                          }
                          copyString +=
                              "${widget.book.nameT}/${getBookNameEng(widget.book.bookNo!)}:${copyVerse.first.chapter!}";
                        }
                        if (theme.format == 'englishTamil') {
                          for (var vm in copyVerse) {
                            copyString += "${vm.verseNo!} ${vm.verseEng}";
                            copyString += "\n";
                            copyString += "${vm.verseTam}";
                            copyString += "\n";
                          }
                          copyString +=
                              "${getBookNameEng(widget.book.bookNo!)}/${widget.book.nameT}:${copyVerse.first.chapter!}";
                        }
                        await Clipboard.setData(
                            ClipboardData(text: copyString));

                        copyVerse.clear();
                        Navigator.pop(context, copyString);
                      },
                      child: Icon(Icons.done),
                    ),
                  )
              ],
            )
          : copyVerse.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<ThemeProvider>(
                      builder: (context, theme, child) => FloatingActionButton(
                          heroTag: "btn_3",
                          onPressed: () async {
                            String copyString = "";
                            if (theme.format == 'onlyTamil') {
                              for (var vm in copyVerse) {
                                copyString += "${vm.verseNo!} ${vm.verseTam}";
                                copyString += "\n";
                              }
                              copyString +=
                                  "${widget.book.nameT}:${copyVerse.first.chapter!}";
                            }
                            if (theme.format == 'onlyEnglish') {
                              for (var vm in copyVerse) {
                                copyString += "${vm.verseNo!} ${vm.verseEng}";
                                copyString += "\n";
                              }
                              copyString +=
                                  "${getBookNameEng(widget.book.bookNo!)}:${copyVerse.first.chapter!}";
                            }
                            if (theme.format == 'tamilEnglish') {
                              for (var vm in copyVerse) {
                                copyString += "${vm.verseNo!} ${vm.verseTam}";
                                copyString += "\n";
                                copyString += "${vm.verseEng}";
                                copyString += "\n";
                              }
                              copyString +=
                                  "${widget.book.nameT}/${getBookNameEng(widget.book.bookNo!)}:${copyVerse.first.chapter!}";
                            }
                            if (theme.format == 'englishTamil') {
                              for (var vm in copyVerse) {
                                copyString += "${vm.verseNo!} ${vm.verseEng}";
                                copyString += "\n";
                                copyString += "${vm.verseTam}";
                                copyString += "\n";
                              }
                              copyString +=
                                  "${getBookNameEng(widget.book.bookNo!)}/${widget.book.nameT}:${copyVerse.first.chapter!}";
                            }
                            await Clipboard.setData(
                                ClipboardData(text: copyString));
                            copyVerse.clear();
                            for (var vm in Provider.of<VerseProvider>(context,
                                    listen: false)
                                .verse) {
                              vm.isSelected = false;
                            }
                            setState(() {});
                          },
                          child: const Icon(Icons.copy)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                        heroTag: "btn_4",
                        onPressed: () async {
                          for (var vm in copyVerse) {
                            await BookMarkService.addBookMark(vm);
                          }
                          for (var vm in Provider.of<VerseProvider>(context,
                                  listen: false)
                              .verse) {
                            vm.isSelected = false;
                          }
                          copyVerse.clear();
                          Fluttertoast.showToast(
                              msg: Provider.of<ThemeProvider>(context,
                                      listen: true)
                                  .addToBookmark);
                          setState(() {});
                        },
                        child: const Icon(Icons.book))
                  ],
                )
              : null,
    );
  }

  Column tamilFollowedByEnglishWidget(VerseModel vm) {
    return Column(
      children: [
        ListTile(
          title: Text(
            vm.verseNo.toString() + ") " + vm.verseTam!,
            style: TextStyle(
                color: vm.isSelected! ? Colors.orange : null,
                fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        ListTile(
          title: Text(
            vm.verseNo.toString() + ") " + vm.verseEng!,
            style: TextStyle(
                color: vm.isSelected! ? Colors.orange : null,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget buildCustomAppBar(
      BuildContext context, GlobalKey<ScaffoldState> _key, BooksModel book) {
    final theme = Provider.of<ThemeProvider>(context);

    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Tooltip(
                        message: getFormattedBookName(theme, widget.book),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ChaptersPage(book: widget.book)));
                          },
                          child: AutoSizeText(
                            getFormattedBookName(theme, widget.book) +
                                ': ${chapter.toString()}',
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxFontSize: 15,
                          ),
                        )),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () => _key.currentState!.openDrawer(),
                      icon: Icon(
                        Icons.view_list,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () => previousChapter(),
                      icon: Icon(Icons.arrow_back_ios_new_rounded)),
                  IconButton(
                      onPressed: () => nextChapter(),
                      icon: Icon(Icons.arrow_forward_ios_rounded)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                            (_) => false);
                      },
                      icon: Icon(Icons.home)),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: false,
                          builder: (BuildContext context) {
                            return BottomSettingsSheet();
                          },
                        );
                      },
                      icon: Icon(Icons.settings)),
                  SfSlider(
                      min: 10,
                      max: 30,
                      value: theme.fontSize,
                      onChanged: ((val) {
                        theme.setFontSize(val);
                      })),
                  IconButton(
                      onPressed: () {
                        theme.toggleTheme();
                      },
                      icon: Icon(theme.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChapterNavigation(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final verseProvider = Provider.of<VerseProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (!widget.isFromnotes)
              ? FloatingActionButton(
                  onPressed: previousChapter,
                  heroTag: "btn1",
                  child: const Icon(Icons.arrow_back),
                )
              : SizedBox(),
          InkWell(
            onTap: () => (widget.isFromnotes)
                ? null
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChaptersPage(book: widget.book))),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      theme.chapterName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      chapter.toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (val) => _scrollController.scrollTo(
                          index: int.parse(val),
                          duration: const Duration(milliseconds: 800)),
                      child: Container(
                        height: 30,
                        width: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Text(
                          "Verse",
                          style: TextStyle(
                              color: theme.isDarkMode ? Colors.black : null,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      itemBuilder: (_) => List.generate(
                          verseProvider.verse.length,
                          (index) => PopupMenuItem<String>(
                                value: index.toString(),
                                child: Text((index + 1).toString()),
                              )),
                    )
                  ],
                ),
              ),
            ),
          ),
          (!widget.isFromnotes)
              ? FloatingActionButton(
                  onPressed: nextChapter,
                  heroTag: "btn2",
                  child: const Icon(Icons.arrow_forward),
                )
              : SizedBox(),
        ],
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

  Column englishFollowedByEnglishWidget(VerseModel vm) {
    return Column(
      children: [
        ListTile(
          title: Text(
            vm.verseNo.toString() + ") " + vm.verseEng!,
            style: TextStyle(
                color: vm.isSelected! ? Colors.orange : null,
                fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        ListTile(
          title: Text(
            vm.verseNo.toString() + ") " + vm.verseTam!,
            style: TextStyle(
                color: vm.isSelected! ? Colors.orange : null,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  ListTile onlyEnglishWidget(VerseModel vm) {
    return ListTile(
      title: Text(
        vm.verseNo.toString() + ") " + vm.verseEng!,
        style: TextStyle(
            color: vm.isSelected! ? Colors.orange : null,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  ListTile onlyTamilWidget(VerseModel vm) {
    return ListTile(
      title: Text(
        vm.verseNo.toString() + ") " + vm.verseTam!,
        style: TextStyle(
            color: vm.isSelected! ? Colors.orange : null,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BottomSettingsSheet extends StatelessWidget {
  const BottomSettingsSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) => SizedBox(
        height: 300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    theme.fontsSize,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: theme.fontSize),
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
                        style: const TextStyle(fontSize: 15),
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
                        fontWeight: FontWeight.bold, fontSize: theme.fontSize),
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
      ),
    );
  }
}




// AppBar(
    //   leading: (widget.isFromnotes)
    //       ? null
    //       : IconButton(
    //           icon: const Icon(Icons.menu, size: 30),
    //           onPressed: () => _key.currentState!.openDrawer()),
    //   centerTitle: true,
    //   automaticallyImplyLeading: false,
    //   title: Tooltip(
    //     message: getFormattedBookName(theme, widget.book),
    //     child: Text(
    //       getFormattedBookName(theme, widget.book),
    //       maxLines: 2,
    //       overflow: TextOverflow.ellipsis,
    //       textAlign: TextAlign.center,
    //       style: const TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: 18,
    //       ),
    //     ),
    //   ),
    //   actions: [
    //     IconButton(
    //         icon: const Icon(Icons.settings),
    //         onPressed: () => showModalBottomSheet<void>(
    //               context: context,
    //               isScrollControlled: false,
    //               builder: (BuildContext context) {
    //                 return BottomSettingsSheet();
    //               },
    //             )),
    //     if (!widget.isFromnotes)
    //       IconButton(
    //           icon: const Icon(Icons.home),
    //           onPressed: () {
    //             Navigator.pushAndRemoveUntil(
    //                 context,
    //                 MaterialPageRoute(builder: (_) => const HomePage()),
    //                 (_) => false);
    //           }),
    //   ],
    //   bottom: PreferredSize(
    //     preferredSize: const Size.fromHeight(100),
    //     child: buildChapterNavigation(context),
    //   ),
    // );