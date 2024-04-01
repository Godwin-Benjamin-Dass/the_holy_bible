import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/provider/books_provider.dart';
import 'package:holy_bible_tamil/provider/theme_provider.dart';
import 'package:holy_bible_tamil/provider/verse_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_flow/home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => BooksProvider()),
    ChangeNotifierProvider(create: (context) => VerseProvider()),
    ChangeNotifierProvider(create: (context) => ThemeProvider())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getPreferece();
  }

  bool isLoading = false;

  getPreferece() async {
    isLoading = true;
    setState(() {});
    Provider.of<ThemeProvider>(context, listen: false).getThemeData();
    isLoading = false;
    setState(() {});
  }

  SharedPreferences? pref;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          )
        : Consumer<ThemeProvider>(
            builder: (context, theme, child) => Builder(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      colorScheme: theme.isDarkMode
                          ? const ColorScheme.dark()
                          : const ColorScheme.light(),
                      useMaterial3: true,
                      listTileTheme: ListTileThemeData(
                          titleTextStyle: TextStyle(
                              fontSize: theme.fontSize,
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.black))),
                  debugShowCheckedModeBanner: false,
                  home: const HomePage());
            }),
          );
  }
}
