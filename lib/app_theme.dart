import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 14, 237, 14);
  static const Color secondaryColor = Color.fromARGB(255, 160, 230, 223);
  static const Color backgroundColor = Color.fromARGB(255, 213, 206, 206);
  static const Color textColor = Color(0xFF000000);

  static ThemeData get themeData {
    return ThemeData(
      highlightColor:  Color.fromARGB(255, 105, 145, 105),
      disabledColor: Color.fromARGB(155, 151, 224, 217),
      hoverColor: Color.fromARGB(255, 238, 171, 132),
      primaryColor: Color.fromARGB(244, 184, 212, 224),     
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary:  Color.fromARGB(255, 238, 171, 132),
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: 'Roboto', fontSize: 24),
        headlineSmall: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontFamily: 'Roboto', fontSize: 20),
      ),
    );
  }
}