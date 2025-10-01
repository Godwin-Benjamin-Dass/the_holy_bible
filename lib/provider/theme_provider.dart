import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/service.dart/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  String _format = '';
  String get format => _format;

  bool _showAppbar = true;

  bool get showAppbar => _showAppbar;

  set toggleAppBar(val) {
    _showAppbar = val;
    print(val);
    notifyListeners();
  }

  setFormat(String value) {
    setText(value);
    _format = value;
    notifyListeners();
    ThemeService.setFormat(value);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    ThemeService.setTheme(_isDarkMode);
  }

  double _fontSize = 12;

  double get fontSize => _fontSize;

  setFontSize(double value) {
    if (value < 10 || value > 30) return;
    _fontSize = value;
    notifyListeners();
    ThemeService.setFont(value);
  }

  getThemeData() async {
    _isDarkMode = await ThemeService.getTheme();
    _fontSize = await ThemeService.getFontSize();
    _format = await ThemeService.getFormat();
    setText(_format);
    notifyListeners();
  }

  String _holyBibeName = "பரிசுத்த வேதாகமம்";
  String get holyBibeName => _holyBibeName;
  String _oldTestamentName = "பழைய\nஏற்பாடு";
  String get oldTestamentName => _oldTestamentName;
  String _continueReadingName = "தொடர்ந்து படிக்கவும்";
  String get continueReadingName => _continueReadingName;
  String _newTestamentName = "புதிய\nஏற்பாடு";
  String get newTestamentName => _newTestamentName;
  String _searchName = "தேடு";
  String get searchName => _searchName;
  String _referece = "குறிப்பு வசனம்";
  String get referece => _referece;
  String _bookmarkName = "புத்தககுறிப்புகள்";
  String get bookmarkName => _bookmarkName;
  String _settingsName = "அமைப்புகள்";
  String get settingsName => _settingsName;
  String _theHolyBibleName = "பரிசுத்த வேதாகமம்";
  String get theHolyBibleName => _theHolyBibleName;
  String _theHolyBible = "பரிசுத்த வேதாகமம்";
  String get theHolyBible => _theHolyBible;
  String _theOldTestamentName = "பழைய ஏற்பாடு";
  String get theOldTestamentName => _theOldTestamentName;
  String get theOldTestament => _theOldTestament;
  String _theOldTestament = "பழைய ஏற்பாடு";
  String _theNewTestamentName = "புதிய ஏற்பாடு";
  String get theNewTestamentName => _theNewTestamentName;
  String _chapterName = "அதிகாரம்";
  String get chapterName => _chapterName;
  String _noBookMarksYet = "இதுவரை புத்தககுறி வசனம் இல்லை";
  String get noBookMarksYet => _noBookMarksYet;
  String _howCanIhelpYou = "உங்களுக்கு எவ்வாறு உதவலாம்";
  String get howCanIhelpYou => _howCanIhelpYou;
  String _copy = "நகல் எடுக்க";
  String get copy => _copy;
  String _gotoVerse = "வசனத்திற்கு செல்லுங்கள்";
  String get gotoVerse => _gotoVerse;
  String _remove = "அகற்று";
  String get remove => _remove;
  String _addToBookMark = "புத்தகக் குறியில் சேர்க்கவும்";
  String get addToBookMark => _addToBookMark;
  String _close = "மூடு";
  String get close => _close;
  String _fontsSize = "எழுத்து அளவு";
  String get fontsSize => _fontsSize;
  String _darkTheme = "இருட்டாக்கு";
  String get darkTheme => _darkTheme;
  String _totalVerse = "மொத்த வசனங்கள்";
  String get totalVerse => _totalVerse;
  String _searchVerse = "தேடல் வசனம்";
  String get searchVerse => _searchVerse;
  String _ended = "முடிந்தது";
  String get ended => _ended;
  String _addToBookmark = "புத்தகக் குறியில் புத்தகக் குறியில்";
  String get addToBookmark => _addToBookmark;
  String _recentVerse = "சமீபத்திய வசனம்";
  String get recentVerse => _recentVerse;
  String _takeNotes = "குறிப்பு எடுங்கள்";
  String get takeNotes => _takeNotes;
  String _myNotes = "என் குறிப்புகள்";
  String get myNotes => _myNotes;
  String _editNotes = "குறிப்பைத் திருத்து";
  String get editNotes => _editNotes;
  String _newNotes = "புதிய குறிப்பு";
  String get newNotes => _newNotes;
  String _noNotesyet = "குறிப்புகள் இன்னும் சேர்க்கப்படவில்லை";
  String get noNotesyet => _noNotesyet;
  String _languageSettings = "மொழி அமைப்புகள்";
  String get languageSettings => _languageSettings;
  String _history = "வரலாறு";
  String get history => _history;
  String _AddToNotes = "Add To Notes";
  String get AddToNotes => _AddToNotes;

  setText(textLangTheme) {
    if (textLangTheme == 'onlyTamil') {
      _holyBibeName = "பரிசுத்த வேதாகமம்";
      _oldTestamentName = "பழைய\nஏற்பாடு";
      _continueReadingName = "தொடர்ந்து படிக்கவும்";
      _newTestamentName = "புதிய\nஏற்பாடு";
      _searchName = "தேடு";
      _referece = "குறிப்பு வசனம்";
      _bookmarkName = "புத்தககுறிப்புகள்";
      _settingsName = "அமைப்புகள்";
      _theHolyBibleName = "பரிசுத்த வேதாகமம்";
      _theOldTestamentName = "பழைய ஏற்பாடு";
      _theNewTestamentName = "புதிய ஏற்பாடு";
      _chapterName = "அதிகாரம்";
      _noBookMarksYet = "இதுவரை புத்தககுறி வசனம் இல்லை";
      _howCanIhelpYou = "உங்களுக்கு எவ்வாறு உதவலாம்";
      _copy = "நகல் எடுக்க";
      _gotoVerse = "வசனத்திற்கு செல்லுங்கள்";
      _remove = "அகற்று";
      _addToBookMark = "புத்தகக் குறியில் சேர்க்கவும்";
      _close = "மூடு";
      _fontsSize = "எழுத்து அளவு";
      _darkTheme = "இருட்டாக்கு";
      _totalVerse = "மொத்த வசனங்கள்";
      _searchVerse = "தேடல் வசனம்";
      _ended = "முடிந்தது";
      _addToBookmark = "புத்தகக் குறியில் புத்தகக் குறியில்";
      _recentVerse = "சமீபத்திய வசனம்";
      _takeNotes = "குறிப்பு எடுங்கள்";
      _myNotes = "என் குறிப்புகள்";
      _editNotes = "குறிப்பைத் திருத்து";
      _newNotes = "புதிய குறிப்பு";
      _noNotesyet = "குறிப்புகள் இன்னும் சேர்க்கப்படவில்லை";
      _languageSettings = "மொழி அமைப்புகள்";
      _history = "வரலாறு";
      _AddToNotes = "குறிப்புகளில் சேர்";
    } else if (textLangTheme == 'onlyEnglish') {
      _holyBibeName = "The Holy Bible";
      _oldTestamentName = "Old\nTestament";
      _continueReadingName = "Continue Reading";
      _newTestamentName = "New\nTestament";
      _searchName = "Search";
      _referece = "Refrence Verse";
      _bookmarkName = "Bookmarks";
      _settingsName = "Settings";
      _theHolyBibleName = "The Holy Bible";
      _theOldTestamentName = "Old Testament";
      _theNewTestamentName = "New Testament";
      _chapterName = "Chapter";
      _noBookMarksYet = "No Bookmarks Yet";
      _howCanIhelpYou = "How can I help you?";
      _copy = "Copy";
      _gotoVerse = "Goto Verse";
      _remove = "Remove";
      _addToBookMark = "Add to Bookmark";
      _close = "Close";
      _fontsSize = "Font Size";
      _darkTheme = "Dark Theme";
      _totalVerse = "Total Verse";
      _searchVerse = "Search Verse";
      _ended = "Ended";
      _addToBookmark = "Add To Bookmark";
      _recentVerse = "Recent Verse";
      _takeNotes = "Take Notes";
      _myNotes = "My Notes";
      _editNotes = "Edit Notes";
      _newNotes = "New Notes";
      _noNotesyet = "No Notes Yet";
      _languageSettings = "Language settings";
      _history = "history";
      _AddToNotes = "Add To Notes";
    } else if (textLangTheme == 'tamilEnglish') {
      _holyBibeName = "பரிசுத்த வேதாகமம்/The Holy Bible";
      _oldTestamentName = "பழைய\nஏற்பாடு/Old\nTestament";
      _continueReadingName = "தொடர்ந்து படிக்கவும்/Continue Reading";
      _newTestamentName = "புதிய\nஏற்பாடு/New\nTestament";
      _searchName = "தேடு/Search";
      _referece = "குறிப்பு வசனம்/Refrence Verse";
      _bookmarkName = "புத்தககுறிப்புகள்/Bookmarks";
      _settingsName = "அமைப்புகள்/Settings";
      _theHolyBibleName = "பரிசுத்த வேதாகமம்/The Holy Bible";
      _theOldTestamentName = "பழைய ஏற்பாடு/Old Testament";
      _theNewTestamentName = "புதிய ஏற்பாடு/NewTestament";
      _chapterName = "அதிகாரம்/Chapter";
      _noBookMarksYet = "இதுவரை புத்தககுறி வசனம் இல்லை/No Bookmarks Yet";
      _howCanIhelpYou = "உங்களுக்கு எவ்வாறு உதவலாம்/How can I help you?";
      _copy = "நகல் எடுக்க/Copy";
      _gotoVerse = "வசனத்திற்கு செல்லுங்கள்/Goto Verse";
      _remove = "அகற்று/ Remove";
      _addToBookMark = "புத்தகக் குறியில் சேர்க்கவும்/Add To Bookmark";
      _recentVerse = "சமீபத்திய வசனம்/Recent Verse";
      _close = "மூடு/Close";
      _fontsSize = "எழுத்து அளவு/Font Size";
      _darkTheme = "இருட்டாக்கு/Dark Theme";
      _totalVerse = "மொத்த வசனங்கள்/Total Verse";
      _searchVerse = "தேடல் வசனம்/Search Verse";
      _ended = "முடிந்தது/Ended";
      _addToBookmark = "புத்தகக் குறியில் புத்தகக் குறியில்/Add To Bookmark";
      _takeNotes = "குறிப்பு எடுங்கள்/Take Notes";
      _myNotes = "என் குறிப்புகள்/My Notes";
      _editNotes = "குறிப்பைத் திருத்து/Edit Notes";
      _newNotes = "புதிய குறிப்பு/New Note";
      _noNotesyet = "குறிப்புகள் இன்னும் சேர்க்கப்படவில்லை/No Notes Yet";
      _languageSettings = "மொழி அமைப்புகள்/Language Settings";
      _history = "வரலாறு/History";
      _AddToNotes = "குறிப்புகளில் சேர்/Add To Notes";
    } else {
      _holyBibeName = "The Holy Bible/பரிசுத்த வேதாகமம்";
      _oldTestamentName = "Old\nTestament/பழைய\nஏற்பாடு";
      _continueReadingName = "Continue Reading/தொடர்ந்து படிக்கவும்";
      _newTestamentName = "New\nTestament/புதிய\nஏற்பாடு";
      _searchName = "Search/தேடு";
      _referece = "Refrence Verse/குறிப்பு வசனம்";
      _bookmarkName = "Bookmarks/புத்தககுறிப்புகள்";
      _settingsName = "Settings/அமைப்புகள்";
      _theHolyBibleName = "The Holy Bible/பரிசுத்த வேதாகமம்";
      _theOldTestamentName = "Old Testament/பழைய ஏற்பாடு";
      _theNewTestamentName = "New Testament/புதிய ஏற்பாடு";
      _chapterName = "Chapter/அதிகாரம்";
      _noBookMarksYet = "No Bookmarks Yet/இதுவரை புத்தககுறி வசனம் இல்லை";
      _howCanIhelpYou = "How can I help you?/உங்களுக்கு எவ்வாறு உதவலாம்";
      _copy = "Copy/நகல் எடுக்க";
      _gotoVerse = "Goto Verse/வசனத்திற்கு செல்லுங்கள்";
      _remove = "Remove/அகற்று";
      _addToBookMark = "Add To Bookmark/புத்தகக் குறியில் சேர்க்கவும்";
      _recentVerse = "Recent Verse/சமீபத்திய வசனம்";
      _close = "Close/மூடு";
      _fontsSize = "Font Size/எழுத்து அளவு";
      _darkTheme = "Dark Theme/இருட்டாக்கு";
      _totalVerse = "Total Verse/மொத்த வசனங்கள்";
      _searchVerse = "Search Verse/தேடல் வசனம்";
      _ended = "Ended/முடிந்தது";
      _addToBookmark = "Add To Bookmark/புத்தகக் குறியில் புத்தகக் குறியில்";
      _takeNotes = "Take Notes/குறிப்பு எடுங்கள்";
      _myNotes = "My Notes/என் குறிப்புகள்";
      _editNotes = "Edit Notes/குறிப்பைத் திருத்து";
      _newNotes = "New Note/புதிய குறிப்பு";
      _noNotesyet = "No Notes Yet/குறிப்புகள் இன்னும் சேர்க்கப்படவில்லை";
      _languageSettings = "Language Settings/மொழி அமைப்புகள்";
      _history = "History/வரலாறு";
      _AddToNotes = "Add To Notes/குறிப்புகளில் சேர்";
    }
    notifyListeners();
  }
}
