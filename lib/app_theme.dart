import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(244, 172, 191, 200);
  static const Color secondaryColor = Color.fromARGB(255, 160, 230, 223);
  static const Color backgroundColor = Color.fromARGB(255, 240, 188, 188);
  static const Color textColor = Color(0xFF000000);
  static const Color buttonColor = Color.fromARGB(255, 165, 150, 230);

  static ThemeData get themeData {
    return ThemeData(
      highlightColor:  Color.fromARGB(255, 105, 145, 105),
      disabledColor: Color.fromARGB(155, 151, 224, 217),
      hoverColor: Color.fromARGB(220, 236, 236, 139),
      primaryColor: Color.fromARGB(244, 172, 191, 200),     
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: 'Roboto', fontSize: 24),
        headlineSmall: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontFamily: 'Roboto', fontSize: 20),
        labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Roboto', fontSize: 20),
      ),
    );
  }
}