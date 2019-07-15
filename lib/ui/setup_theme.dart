import 'package:flutter/material.dart';

import 'colors.dart';

class SetupTheme with ChangeNotifier {
  // static FontWeight _medium = FontWeight.w700;
  // static TextTheme _defaultTextTheme = TextTheme(
  //   title: TextStyle(fontSize: 34, fontWeight: _medium, color: _black),
  // );

  // static Color _backgroundDark = Color(0xFFF1F1F1);
  // static Color _black = Color(0xFFF1F1F1);

  final ThemeData appikoLightTheme = _buildLightTheme();
  final ThemeData appikoDarkTheme = _buildDarkTheme();

  static ThemeData _buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: black,
      primaryColorDark: black,
      primaryColorLight: black.withAlpha(100),
      scaffoldBackgroundColor: backgroundLight,
      backgroundColor: oneColor.withAlpha(100),
      cardColor: surfaceLight,
      textSelectionColor: oneColor.withAlpha(100),
      errorColor: error,
      accentColor: oneColor,
      toggleableActiveColor: oneColor,
      cursorColor: oneColor,
      indicatorColor: oneColor,
      canvasColor: Colors.white,
      primaryColorBrightness: Brightness.dark,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      textSelectionHandleColor: oneColor,
      hintColor: black,
      iconTheme: IconThemeData(color: black),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: black),
        color: Colors.transparent,
        elevation: 0,
        textTheme: TextTheme().copyWith(
          title: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: black,
          ),
        ),
      ),
      textTheme: _buildTextTheme(base.textTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    );
  }

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      primaryColorLight: Colors.white.withAlpha(100),
      backgroundColor: oneColor.withAlpha(100),
      textSelectionColor: oneColor.withAlpha(100),
      errorColor: error,
      accentColor: oneColor,
      toggleableActiveColor: oneColor,
      cursorColor: oneColor,
      indicatorColor: oneColor,
      primaryColorBrightness: Brightness.dark,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      textSelectionHandleColor: oneColor,
      iconTheme: IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        color: Colors.transparent,
        elevation: 0,
        textTheme: TextTheme().copyWith(
          title: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textTheme: _buildTextTheme(base.textTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontWeight: FontWeight.w500,
      ),
      title: base.title.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
      ),
      body1: base.body1.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      caption: base.caption.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
      ),
    );
  }
  // Default Theme
  // ThemeData appikoDefualtTheme = ThemeData(
  //   textTheme: TextTheme(
  //     body1: TextStyle(
  //       fontSize: 18,
  //       fontWeight: FontWeight.bold,
  //       color: Colors.black,
  //     ),
  //     body2: TextStyle(
  //       fontSize: 14,
  //       color: _black,
  //     ),
  //   ),
  //   inputDecorationTheme: InputDecorationTheme(
  //     border: OutlineInputBorder(),
  //   ),
  //   brightness: Brightness.light,
  //   primaryColor: _black,
  //   accentColor: _oneColor,
  //   backgroundColor: _oneColor.withAlpha(100),
  //   floatingActionButtonTheme: FloatingActionButtonThemeData(
  //     backgroundColor: _black,
  //   ),
  //   cursorColor: _oneColor,
  //   scaffoldBackgroundColor: _backgroundLight,
  //   appBarTheme: AppBarTheme(
  //     iconTheme: IconThemeData(color: _black),
  //     color: Colors.transparent,
  //     elevation: 0,
  //     textTheme: _defaultTextTheme,
  //   ),
  // );

  // Dark Theme
  // ThemeData appikoDarkTheme = ThemeData(
  //   brightness: Brightness.dark,
  //   toggleableActiveColor: _oneColor,
  //   backgroundColor: _black.withAlpha(100),
  //   accentColor: _oneColor,
  //   floatingActionButtonTheme: FloatingActionButtonThemeData(
  //     backgroundColor: Colors.white,
  //     foregroundColor: _black,
  //   ),
  //   cursorColor: _oneColor,
  //   textTheme: TextTheme(
  //     body1: TextStyle(
  //       fontSize: 18,
  //       fontWeight: FontWeight.bold,
  //       color: Colors.white,
  //     ),
  //     body2: TextStyle(
  //       fontSize: 14,
  //       color: Colors.white,
  //     ),
  //   ),
  //   inputDecorationTheme: InputDecorationTheme(
  //     border: OutlineInputBorder(),
  //   ),
  //   appBarTheme: AppBarTheme(
  //     iconTheme: IconThemeData(color: Colors.white),
  //     color: Colors.transparent,
  //     elevation: 0,
  //     textTheme: _defaultTextTheme.copyWith(
  //       title: TextStyle(
  //         fontSize: 34,
  //         fontWeight: _medium,
  //         color: Colors.white,
  //       ),
  //     ),
  //   ),
  // );
}
