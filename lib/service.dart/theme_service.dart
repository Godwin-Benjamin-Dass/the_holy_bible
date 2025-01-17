import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static String appThemeKey = "_appTheme";
  static String fontSizeKey = "_fontSize";

  static Future setTheme(bool darkTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(appThemeKey, darkTheme);
  }

  static Future setFont(double fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(fontSizeKey, fontSize);
  }

  static Future getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? theme = prefs.getBool(appThemeKey);
    if (theme == null) {
      await setTheme(false);
      return false;
    } else {
      return theme;
    }
  }

  static Future getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? size = prefs.getDouble(fontSizeKey);
    if (size == null) {
      await setFont(15.0);
      return 15.0;
    } else {
      return size;
    }
  }
}
