import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/models/books_model.dart';
import 'package:holy_bible_tamil/models/verse_model.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:holy_bible_tamil/screens/bible/verse_page.dart';
import 'package:holy_bible_tamil/screens/home_flow/home_page.dart';
import 'package:holy_bible_tamil/service.dart/book_mark_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    clearData();
  }

  clearData() {
    Provider.of<VerseProvider>(context, listen: false).searchVerse.clear();
  }

  TextEditingController searchQuery = TextEditingController();
  double _baseScaleFactor = 1.0;
  String searchLanguage = 'tamil';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          message:
                              Provider.of<ThemeProvider>(context, listen: true)
                                  .searchName,
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * .6,
                            child: AutoSizeText(
                              Provider.of<ThemeProvider>(context, listen: true)
                                  .searchName,
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
                                              Provider.of<ThemeProvider>(
                                                      context,
                                                      listen: true)
                                                  .fontsSize,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Provider.of<
                                                              ThemeProvider>(
                                                          context,
                                                          listen: true)
                                                      .fontSize),
                                            ),
                                            SfSlider(
                                                min: 10,
                                                max: 30,
                                                value:
                                                    Provider.of<ThemeProvider>(
                                                            context,
                                                            listen: true)
                                                        .fontSize,
                                                onChanged: ((val) {
                                                  Provider.of<ThemeProvider>(
                                                          context,
                                                          listen: true)
                                                      .setFontSize(val);
                                                })),
                                            Row(
                                              children: [
                                                Text(
                                                  Provider.of<ThemeProvider>(
                                                          context,
                                                          listen: true)
                                                      .darkTheme,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                const Spacer(),
                                                Switch(
                                                    value: Provider.of<
                                                                ThemeProvider>(
                                                            context,
                                                            listen: true)
                                                        .isDarkMode,
                                                    onChanged: ((val) {
                                                      Provider.of<ThemeProvider>(
                                                              context,
                                                              listen: true)
                                                          .toggleTheme();
                                                    }))
                                              ],
                                            ),
                                            Text(
                                              'Select format',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Provider.of<
                                                              ThemeProvider>(
                                                          context,
                                                          listen: true)
                                                      .fontSize),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                Provider.of<ThemeProvider>(
                                                        context,
                                                        listen: true)
                                                    .setFormat('tamilEnglish');
                                              },
                                              leading: Radio(
                                                  value: 'tamilEnglish',
                                                  groupValue: Provider.of<
                                                              ThemeProvider>(
                                                          context,
                                                          listen: true)
                                                      .format,
                                                  onChanged: (val) {
                                                    Provider.of<ThemeProvider>(
                                                            context,
                                                            listen: true)
                                                        .setFormat(val!);
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
                                                Provider.of<ThemeProvider>(
                                                        context,
                                                        listen: true)
                                                    .setFormat('englishTamil');
                                              },
                                              leading: Radio(
                                                  value: 'englishTamil',
                                                  groupValue: Provider.of<
                                                              ThemeProvider>(
                                                          context,
                                                          listen: true)
                                                      .format,
                                                  onChanged: (val) {
                                                    Provider.of<ThemeProvider>(
                                                            context,
                                                            listen: true)
                                                        .setFormat(val!);
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
                                                Provider.of<ThemeProvider>(
                                                        context,
                                                        listen: true)
                                                    .setFormat('onlyTamil');
                                              },
                                              leading: Radio(
                                                  value: 'onlyTamil',
                                                  groupValue: Provider.of<
                                                              ThemeProvider>(
                                                          context,
                                                          listen: true)
                                                      .format,
                                                  onChanged: (val) {
                                                    Provider.of<ThemeProvider>(
                                                            context,
                                                            listen: true)
                                                        .setFormat(val!);
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
                                                Provider.of<ThemeProvider>(
                                                        context,
                                                        listen: true)
                                                    .setFormat('onlyEnglish');
                                              },
                                              leading: Radio(
                                                  value: 'onlyEnglish',
                                                  groupValue: Provider.of<
                                                              ThemeProvider>(
                                                          context,
                                                          listen: true)
                                                      .format,
                                                  onChanged: (val) {
                                                    Provider.of<ThemeProvider>(
                                                            context,
                                                            listen: true)
                                                        .setFormat(val!);
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
        body: Consumer<VerseProvider>(
          builder: (context, verse, child) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: searchQuery,
                    decoration: InputDecoration(
                        hintText:
                            Provider.of<ThemeProvider>(context, listen: true)
                                .searchVerse,
                        border: const OutlineInputBorder()),
                    onSubmitted: (value) async {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Select Language',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        searchLanguage = 'tamil';
                      });
                    },
                    leading: Radio(
                        value: 'tamil',
                        groupValue: searchLanguage,
                        onChanged: (val) {
                          setState(() {
                            searchLanguage = 'tamil';
                          });
                        }),
                    title: Text(
                      'தமிழ்',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        searchLanguage = 'english';
                      });
                    },
                    leading: Radio(
                        value: 'english',
                        groupValue: searchLanguage,
                        onChanged: (val) {
                          setState(() {
                            searchLanguage = 'english';
                          });
                        }),
                    title: Text(
                      'English',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (searchQuery.text.trim() == "") {
                          Provider.of<VerseProvider>(context, listen: false)
                              .searchVerse
                              .clear();
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child: CircularProgressIndicator());
                              });
                          await Future.delayed(Duration(seconds: 1));
                          await verse
                              .filterSearchResults(
                                  searchQuery.text.trim(), searchLanguage)
                              .then((value) => Navigator.pop(context));
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search),
                          Text(Provider.of<ThemeProvider>(context, listen: true)
                              .searchName),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "${Provider.of<ThemeProvider>(context, listen: true).totalVerse}: ${verse.searchVerse.length}"),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      itemCount: verse.searchVerse.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        VerseModel vm = verse.searchVerse[i];
                        return GestureDetector(
                          onScaleStart: (details) {
                            _baseScaleFactor = Provider.of<ThemeProvider>(
                                    context,
                                    listen: false)
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
                                // title: Text(howCanIhelpYou),
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
                                      child: Text(Provider.of<ThemeProvider>(
                                              context,
                                              listen: true)
                                          .copy),
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
                                                          nameE: getBookNameEng(
                                                              vm.book!),
                                                          nameT: getBookName(
                                                              vm.book!),
                                                          noOfBooks: bibleBooks[
                                                              getBookName(
                                                                  vm.book!)]),
                                                      chapter: vm.chapter!,
                                                      verseNo: vm.verseNo,
                                                    )));
                                      },
                                      child: Text(Provider.of<ThemeProvider>(
                                              context,
                                              listen: true)
                                          .gotoVerse),
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
                                      child: Text(Provider.of<ThemeProvider>(
                                              context,
                                              listen: true)
                                          .addToBookMark),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Consumer<ThemeProvider>(
                              builder: (context, theme, child) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Provider.of<ThemeProvider>(
                                                    context,
                                                    listen: false)
                                                .isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                child: theme.format == 'onlyTamil'
                                    ? onlyTamilMethod(vm)
                                    : theme.format == 'onlyEnglish'
                                        ? onlyEnglishMethod(vm)
                                        : theme.format == 'tamilEnglish'
                                            ? tamilFollowedEnglishMethod(vm)
                                            : englishFollowedTamilMethod(vm),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ));
  }

  Column onlyEnglishMethod(VerseModel vm) {
    return Column(
      children: [
        ListTile(
          title: Text(vm.verseEng!),
        ),
        Text(
          "${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column onlyTamilMethod(VerseModel vm) {
    return Column(
      children: [
        ListTile(
          title: Text(vm.verseTam!),
        ),
        Text(
          "${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column tamilFollowedEnglishMethod(VerseModel vm) {
    return Column(
      children: [
        ListTile(
          title: Text(vm.verseTam!),
        ),
        Text(
          "${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Divider(),
        ListTile(
          title: Text(vm.verseEng!),
        ),
        Text(
          "${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

  Column englishFollowedTamilMethod(VerseModel vm) {
    return Column(
      children: [
        ListTile(
          title: Text(vm.verseEng!),
        ),
        Text(
          "${getBookNameEng(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Divider(),
        ListTile(
          title: Text(vm.verseTam!),
        ),
        Text(
          "${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
