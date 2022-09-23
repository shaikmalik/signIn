import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  late ThemeData _themeData;
  ThemeNotifier(this._themeData);
  ThemeData get getTheme => _themeData;

  setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}

ThemeData activeTheme = darkTheme;

final darkTheme = ThemeData(
  primaryColor: Colors.black,
  accentColor: Colors.grey,
  brightness: Brightness.dark,
);

final lightTheme = ThemeData(
  primaryColor: Colors.black,
  accentColor: Colors.white,
  brightness: Brightness.light,
);

final systemTheme = ThemeData(
    primaryColor: Colors.blue,
    accentColor: Colors.grey,
    brightness: Brightness.light);