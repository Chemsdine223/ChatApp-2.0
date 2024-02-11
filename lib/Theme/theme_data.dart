import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = const Color(0x00ffffff);
  Color darkPrimaryColor = const Color(0xFF151B54);

  // ThemeClass._();

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.light(primary: _themeClass.lightPrimaryColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _themeClass.darkPrimaryColor,
      ));
  static ThemeData dark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _themeClass.darkPrimaryColor,
      ));
}

ThemeClass _themeClass = ThemeClass();
