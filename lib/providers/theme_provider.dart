import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  // Custom color
  MaterialColor _primaryColor = Colors.deepPurple;
  MaterialColor get primaryColor => _primaryColor;

  void setPrimaryColor(MaterialColor color) {
    _primaryColor = color;
    notifyListeners();
  }
}
