import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(color: Colors.white),
    colorScheme: ColorScheme.light(
        primary: Colors.grey[700]!,
        secondary: Colors.grey[400]!,
        tertiary: Colors.grey[200]!,
        surface: Colors.white,
        inversePrimary: Colors.black),
    scaffoldBackgroundColor: Colors.white);
