import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = lightMode;
  ThemeData get currentTheme => _currentTheme;

  bool get isDarkMode => _currentTheme == darkMode;

  set currentTheme(ThemeData themeData) {
    _currentTheme = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_currentTheme == lightMode) {
      _currentTheme = darkMode;
    } else {
      _currentTheme = lightMode;
    }
    notifyListeners();
  }
}
