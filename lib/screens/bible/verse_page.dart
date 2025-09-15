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
import 'package:share_plus/share_plus.dart';
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
            // scroll down by at least 2 items
            onScrollDown();
          } else if (firstVisibleItemIndex < _previousFirstIndex!) {
            // scroll up by at least 2 items
            onScrollUp();
          }
        }

        _previousFirstIndex = firstVisibleItemIndex;
      }
    });
    Provider.of<ThemeProvider>(context, listen: false).toggleAppBar = true;
  }

  bool showAppBar = true;
  bool oldTest = false;
  bool newTest = false;

  void onScrollUp() {
    print("User scrolled UP");
    if (!Provider.of<ThemeProvider>(context, listen: false).showAppbar) {
      Provider.of<ThemeProvider>(context, listen: false).toggleAppBar = true;
    }
    // Add your logic here
  }

  void onScrollDown() {
    print("User scrolled DOWN");
    if (Provider.of<ThemeProvider>(context, listen: false).showAppbar) {
      Provider.of<ThemeProvider>(context, listen: false).toggleAppBar = false;
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
          child: Provider.of<ThemeProvider>(context, listen: true).showAppbar
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
                isSwipable: !widget.isFromnotes,
                onSwipeLeft: () => nextChapter(),
                onSwipeRight: () => previousChapter(),
                child: ScrollablePositionedList.builder(
                  padding: EdgeInsets.only(
                    bottom: 100 + MediaQuery.of(context).padding.bottom,
                  ),
                  physics: ClampingScrollPhysics(),
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
                                        : englishFollowedByTamilWidget(vm),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                            Share.share(copyString);

                            for (var vm in Provider.of<VerseProvider>(context,
                                    listen: false)
                                .verse) {
                              vm.isSelected = false;
                            }
                            setState(() {});
                          },
                          child: const Icon(Icons.share)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer<ThemeProvider>(
                          builder: (context, theme, child) =>
                              FloatingActionButton(
                                  heroTag: "btn_3",
                                  onPressed: () async {
                                    String copyString = "";
                                    if (theme.format == 'onlyTamil') {
                                      for (var vm in copyVerse) {
                                        copyString +=
                                            "${vm.verseNo!} ${vm.verseTam}";
                                        copyString += "\n";
                                      }
                                      copyString +=
                                          "${widget.book.nameT}:${copyVerse.first.chapter!}";
                                    }
                                    if (theme.format == 'onlyEnglish') {
                                      for (var vm in copyVerse) {
                                        copyString +=
                                            "${vm.verseNo!} ${vm.verseEng}";
                                        copyString += "\n";
                                      }
                                      copyString +=
                                          "${getBookNameEng(widget.book.bookNo!)}:${copyVerse.first.chapter!}";
                                    }
                                    if (theme.format == 'tamilEnglish') {
                                      for (var vm in copyVerse) {
                                        copyString +=
                                            "${vm.verseNo!} ${vm.verseTam}";
                                        copyString += "\n";
                                        copyString += "${vm.verseEng}";
                                        copyString += "\n";
                                      }
                                      copyString +=
                                          "${widget.book.nameT}/${getBookNameEng(widget.book.bookNo!)}:${copyVerse.first.chapter!}";
                                    }
                                    if (theme.format == 'englishTamil') {
                                      for (var vm in copyVerse) {
                                        copyString +=
                                            "${vm.verseNo!} ${vm.verseEng}";
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
                                    for (var vm in Provider.of<VerseProvider>(
                                            context,
                                            listen: false)
                                        .verse) {
                                      vm.isSelected = false;
                                    }
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.copy)),
                        ),
                        SizedBox(
                          width: 10,
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
                                          listen: false)
                                      .addToBookmark);
                              setState(() {});
                            },
                            child: const Icon(Icons.book)),
                      ],
                    )
                  ],
                )
              : null,
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
                    width: MediaQuery.of(context).size.width * 0.4,
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
                            maxFontSize: 13,
                          ),
                        )),
                  ),
                  Spacer(),
                  if (widget.isFromnotes == false)
                    IconButton(
                        onPressed: () => _key.currentState!.openDrawer(),
                        icon: Icon(
                          Icons.view_list,
                          size: 30,
                        )),
                  if (widget.isFromnotes == false)
                    IconButton(
                        onPressed: () => previousChapter(),
                        icon: Icon(Icons.arrow_back_ios_new_rounded)),
                  if (widget.isFromnotes == false)
                    IconButton(
                        onPressed: () => nextChapter(),
                        icon: Icon(Icons.arrow_forward_ios_rounded)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.isFromnotes == false)
                    GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()),
                              (_) => false);
                        },
                        child: Icon(Icons.home)),
                  GestureDetector(
                      onTap: () => _showSettingsSheet(context, theme),
                      child: Icon(Icons.settings)),
                  SfSlider(
                      min: 10,
                      max: 30,
                      value: theme.fontSize,
                      onChanged: ((val) {
                        theme.setFontSize(val);
                      })),
                  GestureDetector(
                      onTap: () {
                        theme.toggleTheme();
                      },
                      child: Icon(theme.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode)),
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      _scrollController.scrollTo(
                          index: int.parse(value),
                          duration: const Duration(milliseconds: 800));
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
                    itemBuilder: (BuildContext context) => List.generate(
                        Provider.of<VerseProvider>(context, listen: false)
                            .verse
                            .length, (index) {
                      return PopupMenuItem<String>(
                        value: index.toString(),
                        child: Text((index + 1).toString()),
                      );
                    }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

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

  Widget tamilFollowedByEnglishWidget(VerseModel vm) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: vm.isSelected! ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${vm.verseNo}) ${vm.verseTam!}",
              style: TextStyle(
                fontSize: Provider.of<ThemeProvider>(context).fontSize,
                fontWeight: FontWeight.bold,
                color: vm.isSelected! ? Colors.orange : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${vm.verseNo}) ${vm.verseEng!}",
              style: TextStyle(
                fontSize: Provider.of<ThemeProvider>(context).fontSize,
                fontWeight: FontWeight.w500,
                color: vm.isSelected! ? Colors.orange : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget englishFollowedByTamilWidget(VerseModel vm) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: vm.isSelected! ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${vm.verseNo}) ${vm.verseEng!}",
              style: TextStyle(
                fontSize: Provider.of<ThemeProvider>(context).fontSize,
                fontWeight: FontWeight.bold,
                color: vm.isSelected! ? Colors.orange : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${vm.verseNo}) ${vm.verseTam!}",
              style: TextStyle(
                fontSize: Provider.of<ThemeProvider>(context).fontSize,
                fontWeight: FontWeight.w500,
                color: vm.isSelected! ? Colors.orange : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget onlyEnglishWidget(VerseModel vm) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: vm.isSelected! ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "${vm.verseNo}) ${vm.verseEng!}",
          style: TextStyle(
            fontSize: Provider.of<ThemeProvider>(context).fontSize,
            fontWeight: FontWeight.bold,
            color: vm.isSelected! ? Colors.orange : null,
          ),
        ),
      ),
    );
  }

  Widget onlyTamilWidget(VerseModel vm) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: vm.isSelected! ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "${vm.verseNo}) ${vm.verseTam!}",
          style: TextStyle(
            fontSize: Provider.of<ThemeProvider>(context).fontSize,
            fontWeight: FontWeight.bold,
            color: vm.isSelected! ? Colors.orange : null,
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