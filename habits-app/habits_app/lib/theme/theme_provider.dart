import 'package:flutter/material.dart';
import 'package:habits_app/database/habit_database.dart';
import 'package:habits_app/theme/dark_mode.dart';
import 'package:habits_app/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  Future<void> initTheme(HabitDatabase db) async {
    final isDark = await db.isDarkMode();
    _themeData = (isDark ?? false) ? darkMode : lightMode;
    notifyListeners();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(HabitDatabase db) {
    if (_themeData == lightMode) {
      themeData = darkMode;
      db.setThemeMode(true);
    } else {
      themeData = lightMode;
      db.setThemeMode(false);
    }
  }
}
