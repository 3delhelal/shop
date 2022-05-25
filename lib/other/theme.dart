import 'package:flutter/material.dart';

import '/other/constants.dart';

// This is our  main focus
// Let's apply light and dark theme on our app
// Now let's add dark theme on our app

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: const IconThemeData(color: kContentColorLightTheme),
    // textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
    //   bodyColor: kContentColorLightTheme,
    // ),
    textTheme: ThemeData.light().textTheme.copyWith(),
    // accentTextTheme:
    //     TextTheme(subtitle2: TextStyle(fontSize: 40, color: Colors.green)),
    primaryTextTheme: ThemeData.light().textTheme.copyWith(
        // headline6: TextStyle(color: Colors.green, fontSize: 35),
        headline5: const TextStyle(color: Colors.green, fontSize: 35),
        // headline3: TextStyle(color: Colors.green, fontSize: 35),
        // headline2: TextStyle(color: Colors.green, fontSize: 35),
        // headline1: TextStyle(color: Colors.green, fontSize: 35),
        // headline4: TextStyle(color: Colors.green, fontSize: 35),
        // bodyText1: TextStyle(color: Colors.green, fontSize: 35),
        // bodyText2: TextStyle(color: Colors.green, fontSize: 35),
        caption: const TextStyle(color: Colors.green, fontSize: 35),
        subtitle1: const TextStyle(color: Colors.green, fontSize: 35),
        subtitle2: const TextStyle(color: Colors.green, fontSize: 35)),
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  // Bydefault flutter provie us light and dark theme
  // we just modify it as our need
  return ThemeData.dark().copyWith(
    canvasColor: Colors.pink,
    // accentColor: Colors.pink,
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.pink,
        selectionColor: Colors.pink,
        selectionHandleColor: Colors.pink),
    bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: kContentColorDarkTheme),
    dialogTheme:
        const DialogTheme(contentTextStyle: TextStyle(color: Colors.amber)),
    inputDecorationTheme: const InputDecorationTheme(
      focusColor: Colors.white,
      counterStyle: TextStyle(color: Colors.white, fontSize: 40),
      hintStyle: TextStyle(color: Colors.grey),
      helperStyle: TextStyle(color: Colors.white, fontSize: 40),
      fillColor: Colors.blue,
      hoverColor: Colors.blue,
    ),

    hintColor: Colors.grey,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: appBarTheme,
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    // textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
    //     .apply(bodyColor: kContentColorDarkTheme),
    textTheme: ThemeData.dark()
        .textTheme
        .copyWith(headline5: const TextStyle(color: Colors.black)),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

const appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
