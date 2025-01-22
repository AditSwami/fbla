import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppUi {
  static final backgroundDark = Color.fromARGB(255, 17, 17, 17);
  static final grey = Color.fromARGB(255, 158, 158, 158);
  static final primary = Color.fromRGBO(112, 255, 131, 1);
  static final offWhite = Color.fromARGB(255, 239, 239, 239);
}

ThemeData darkMode = ThemeData(
  splashFactory: NoSplash.splashFactory,
  textTheme: TextTheme(
    titleLarge: GoogleFonts.jost(
      fontWeight: FontWeight.w700,
      color: AppUi.offWhite,
      fontSize: 30,
    ),
    titleMedium: GoogleFonts.jost(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    titleSmall: GoogleFonts.jost(
        fontWeight: FontWeight.w500,
        color: AppUi.grey,
        fontSize: 15,
      ),
    labelLarge: GoogleFonts.jost(
      color: AppUi.offWhite,
      fontSize: 18
    ),
    labelMedium: GoogleFonts.jost(
      color: AppUi.offWhite,
      fontSize: 15
    ),
    labelSmall: GoogleFonts.jost(
            color: AppUi.offWhite,
            fontSize: 13
    ),
    bodyLarge: GoogleFonts.jost(
      color: AppUi.offWhite,
      fontSize: 18
    ),
    bodyMedium: GoogleFonts.jost(
      color: AppUi.offWhite,
      fontSize: 16
    ),
    bodySmall: GoogleFonts.jost(
      color: AppUi.grey,
      fontSize: 13
    )

  ),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: AppUi.backgroundDark,
      primary: AppUi.primary,
      secondary: AppUi.grey,
    ));
