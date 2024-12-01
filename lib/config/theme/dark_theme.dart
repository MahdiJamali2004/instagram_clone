import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(color: Colors.grey[900]),
    colorScheme: ColorScheme.dark(
        primary: Colors.grey[700]!,
        secondary: Colors.grey[500]!,
        tertiary: Colors.grey[300],
        surface: Colors.grey[900]!,
        inversePrimary: Colors.grey[200]),
    scaffoldBackgroundColor: Colors.grey[900]);
