// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/data/constants.dart';
import 'package:holy_bible_tamil/provider/books_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(theHolyBibleName),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 30),
          child: TabBar(
            unselectedLabelColor: Colors.grey,
            controller: tabController,
            tabs: [
              Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(theOldTestamentName)),
              Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(theNewTestamentName)),
            ],
          ),
        ),
      ),
      body: Consumer<BooksProvider>(
        builder: (context, book, child) => TabBarView(
          controller: tabController,
          children: [
            ListOfBooks(books: book.oldTestament),
            ListOfBooks(books: book.newTestament)
          ],
        ),
      ),
    );
  }
}
