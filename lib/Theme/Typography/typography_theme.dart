import 'package:google_fonts/google_fonts.dart';

import '../colors/color_palettes.dart';

class CustomTypography {
  final textThemeLight = GoogleFonts.abelTextTheme().apply(
    bodyColor: ColorPalettes().lightPrimaryColor,
  );
  final textThemeDark = GoogleFonts.abelTextTheme()
      .apply(
        bodyColor: ColorPalettes().darkPrimaryColor,
      )
      .copyWith(
        bodySmall: GoogleFonts.abelTextTheme()
            .bodySmall!
            .copyWith(color: ColorPalettes().darkPrimaryColor),
      );
}
