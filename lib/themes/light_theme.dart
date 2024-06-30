import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    primaryColor: const Color(0xFFFFFFFF),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFFFFF),
      brightness: Brightness.light,
      primary: const Color(0xFF007AFF),
      onPrimary: const Color(0xFFFFFFFF),
    ),
    cardColor: const Color(0xFFFFFFFF),
    scaffoldBackgroundColor: const Color(0xFFF7F6F2),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF007AFF), foregroundColor: Colors.white),
  );
}
