import 'package:chat_app/Theme/Typography/typography_theme.dart';
import 'package:flutter/material.dart';

class ComponentThemes {
  final lightlistTileTheme = ListTileThemeData(
    subtitleTextStyle: CustomTypography().textThemeLight.bodySmall,
  );
  final darklistTileTheme = ListTileThemeData(
    subtitleTextStyle: CustomTypography().textThemeDark.bodySmall,
  );
}
