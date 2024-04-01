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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(searchName), actions: [
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
        body: Consumer<VerseProvider>(
          builder: (context, verse, child) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onScaleStart: (details) {
                _baseScaleFactor =
                    Provider.of<ThemeProvider>(context, listen: false).fontSize;
              },
              onScaleUpdate: (details) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setFontSize(_baseScaleFactor * details.scale);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: searchQuery,
                      decoration: InputDecoration(
                          hintText: searchVerse,
                          border: const OutlineInputBorder()),
                      onSubmitted: (value) async {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
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
                                .filterSearchResults(searchQuery.text.trim())
                                .then((value) => Navigator.pop(context));
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search),
                            Text(searchName),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("$totalVerse: ${verse.searchVerse.length}"),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        itemCount: verse.searchVerse.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) {
                          VerseModel vm = verse.searchVerse[i];
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(howCanIhelpYou),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  builder: (context) =>
                                                      VersePage(
                                                        book: BooksModel(
                                                            bookNo: vm.book,
                                                            name: getBookName(
                                                                vm.book!),
                                                            noOfBooks: bibleBooks[
                                                                getBookName(
                                                                    vm.book!)]),
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
                                        onTap: () {
                                          BookMarkService.addBookMark(vm)
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(addToBookMark),
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
                                        color: Provider.of<ThemeProvider>(
                                                    context,
                                                    listen: false)
                                                .isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(vm.verse!),
                                    ),
                                    Text(
                                      "${getBookName(vm.book!)} ${vm.chapter!}:${vm.verseNo!}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
