import 'package:chat_app/Theme/Typography/typography_theme.dart';
import 'package:chat_app/Theme/colors/color_palettes.dart';
import 'package:chat_app/Theme/components_themes.dart';
import 'package:flutter/material.dart';

class ThemeClass {
  Color darkPrimaryColor = Colors.white;
  Color lightPrimaryColor = Colors.black;

  static ThemeData lightTheme = ThemeData(
    splashColor: ColorPalettes().accentColor,
    primaryColor: Colors.black,
    canvasColor: ColorPalettes().lightsurfaceColor,
    textTheme: CustomTypography().textThemeLight,
    listTileTheme: ComponentThemes().lightlistTileTheme,
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: ColorPalettes().lightPrimaryColor,
    ),
  );

  static ThemeData dark = ThemeData(
    // colorSchemeSeed: ,
    splashColor: ColorPalettes().accentColor,
    canvasColor: ColorPalettes().darksurfaceColor,
    primaryColor: ColorPalettes().darkPrimaryColor,
    textTheme: CustomTypography().textThemeDark,
    listTileTheme: ComponentThemes().darklistTileTheme,
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      // surface: ColorPalettes().darksurfaceColor,
      primary: ColorPalettes().darkPrimaryColor,
    ),
  );
}

// ThemeClass _themeClass = ThemeClass();
