import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppUi {
  static final backgroundDark = Color.fromARGB(255, 17, 17, 17);
  static final grey = Color.fromARGB(255, 109, 109, 109);
  static final primary = Color.fromRGBO(112, 255, 131, 1);
  static final offWhite = Color.fromARGB(255, 239, 239, 239);
}

ThemeData darkMode = ThemeData(
  textTheme: TextTheme(
    titleLarge: GoogleFonts.jost(
      fontWeight: FontWeight.w700,
      color: AppUi.primary,
      fontSize: 30,
    ),
    titleMedium: GoogleFonts.jost(
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    titleSmall: GoogleFonts.jost(
        fontWeight: FontWeight.w500,
        color: AppUi.grey,
        fontSize: 15,
      ),
  ),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: AppUi.backgroundDark,
      primary: AppUi.primary,
      secondary: AppUi.grey
    ));