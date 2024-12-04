import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      surface: _surfaceColor,
      onPrimary: _primaryColor,
      onPrimaryFixed: _hintTextColor,
      primary: Colors.white,
    ),
    useMaterial3: true,
    elevatedButtonTheme: _elevatedButtonTheme,
    textTheme: const TextTheme(
      displayLarge: _displayLarge,
      titleMedium: _titleMedium,
      titleSmall: _titleSmall,
    ),
    inputDecorationTheme: InputDecorationTheme(border: _border),
  );

  final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      onPrimaryFixed: _hintTextColor,
      primary: Colors.black,
      onPrimary: Color.fromARGB(255, 241, 238, 239),
    ),
    useMaterial3: true,
    elevatedButtonTheme: _elevatedButtonTheme,
    textTheme: const TextTheme(
      displayLarge: _displayLarge,
      titleMedium: _titleMedium,
      titleSmall: _titleSmall,
    ),
    inputDecorationTheme: InputDecorationTheme(border: _border),
  );

  static const _surfaceColor = Color.fromRGBO(37, 37, 37, 1);
  static const _primaryColor = Color.fromRGBO(59, 59, 59, 1);
  static const _displayLarge =
      TextStyle(fontSize: 35, fontWeight: FontWeight.bold);
  static const _titleMedium = TextStyle(fontSize: 16, color: Colors.red);
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)))));
  static const _hintTextColor = Color.fromARGB(255, 194, 191, 191);
  static const _titleSmall = TextStyle(color: Colors.black, fontSize: 25);
  static final OutlineInputBorder _border =
      OutlineInputBorder(borderRadius: BorderRadius.circular(13));
}
