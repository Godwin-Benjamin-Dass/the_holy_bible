// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/provider/books_provider.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/widgets/list_of_books.dart';
import 'package:provider/provider.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key, this.idx = 0});
  final int idx;

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: widget.idx,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) => Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 115),
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
                          message: theme.theHolyBibleName,
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * .6,
                            child: AutoSizeText(
                              theme.theHolyBibleName,
                              maxFontSize: 17,
                              minFontSize: 17,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                    ],
                  ),
                  TabBar(
                    unselectedLabelColor: Colors.grey,
                    controller: tabController,
                    tabs: [
                      Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: AutoSizeText(
                              maxFontSize: 17, theme.theOldTestamentName)),
                      Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: AutoSizeText(
                              maxFontSize: 17, theme.theNewTestamentName)),
                    ],
                  )
                ],
              ),
            ))
        //  AppBar(
        //   automaticallyImplyLeading: false,
        //   title: ,
        //   bottom: PreferredSize(
        //     preferredSize: const Size(double.infinity, 30),
        //     child: TabBar(
        //       unselectedLabelColor: Colors.grey,
        //       controller: tabController,
        //       tabs: [
        //         Container(
        //             alignment: Alignment.center,
        //             height: 50,
        //             child: Text(theme.theOldTestamentName)),
        //         Container(
        //             alignment: Alignment.center,
        //             height: 50,
        //             child: Text(theme.theNewTestamentName)),
        //       ],
        //     ),
        //   ),
        // ),
        ,
        body: Consumer<BooksProvider>(
          builder: (context, book, child) => TabBarView(
            controller: tabController,
            children: [
              ListOfBooks(books: book.oldTestament),
              ListOfBooks(books: book.newTestament)
            ],
          ),
        ),
      ),
    );
  }
}
