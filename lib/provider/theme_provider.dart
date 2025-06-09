import 'package:flutter/material.dart';
import 'package:holy_bible_tamil/service.dart/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

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
    notifyListeners();
  }
}
