import 'package:flutter/material.dart';
import 'package:notes_app/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  // initially theme is light mode
  // Stores the actual value (private field).
  ThemeData _themeData = lightMode;
  
  // Safely exposes the theme to other parts of the app.
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
