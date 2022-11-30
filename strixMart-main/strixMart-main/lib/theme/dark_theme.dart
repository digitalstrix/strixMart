import 'package:flutter/material.dart';

ThemeData dark({Color color = const Color.fromARGB(255, 255, 174, 103)}) =>
    ThemeData(
      fontFamily: 'Roboto',
      primaryColor: color,
      secondaryHeaderColor: Color.fromARGB(255, 151, 109, 72),
      disabledColor: Color(0xffa2a7ad),
      backgroundColor: Color(0xFF343636),
      errorColor: Color(0xFFdd3135),
      brightness: Brightness.dark,
      hintColor: Color(0xFFbebebe),
      cardColor: Colors.black,
      colorScheme: ColorScheme.dark(primary: color, secondary: color),
      textButtonTheme:
          TextButtonThemeData(style: TextButton.styleFrom(primary: color)),
    );
