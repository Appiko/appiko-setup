import 'package:flutter/material.dart';

class SetupTheme with ChangeNotifier {
  static Color _oneColor = Color(0xFFE06B1E);
  static Color _black = Color(0xFF1F1F1F);
  static Color _backgroundLight = Color(0xFFEDF0F2);
  static FontWeight _medium = FontWeight.w700;
  static TextTheme _defaultTextTheme = TextTheme(
    title: TextStyle(fontSize: 34, fontWeight: _medium, color: _black),
  );

  // static Color _backgroundDark = Color(0xFFF1F1F1);
  // static Color _black = Color(0xFFF1F1F1);

  // Default Theme
  ThemeData appikoDefualtTheme = ThemeData(
    textTheme: TextTheme(
      body1: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      body2: TextStyle(
        fontSize: 14,
        color: _black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    brightness: Brightness.light,
    primaryColor: _black,
    accentColor: _oneColor,
    backgroundColor: _oneColor.withAlpha(100),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _black,
    ),
    cursorColor: _oneColor,
    scaffoldBackgroundColor: _backgroundLight,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: _black),
      color: Colors.transparent,
      elevation: 0,
      textTheme: _defaultTextTheme,
    ),
  );

  // Dark Theme
  ThemeData appikoDarkTheme = ThemeData(
    brightness: Brightness.dark,
    toggleableActiveColor: _oneColor,
    backgroundColor: _black.withAlpha(100),
    accentColor: _oneColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: _black,
    ),
    cursorColor: _oneColor,
    textTheme: TextTheme(
      body1: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      body2: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      color: Colors.transparent,
      elevation: 0,
      textTheme: _defaultTextTheme.copyWith(
        title: TextStyle(
          fontSize: 34,
          fontWeight: _medium,
          color: Colors.white,
        ),
      ),
    ),
  );
}
