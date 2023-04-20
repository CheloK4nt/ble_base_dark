import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData? _selectedTheme;

  ThemeData dark = ThemeData.dark().copyWith(
    // ignore: prefer_const_constructors
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.grey.shade800
    )
    // colorScheme: ColorScheme.dark(
    //   brightness: Brightness.dark,
    //   primary: Colors.grey.shade800,
    //   onPrimary: Colors.white,
    //   secondary: Colors.grey.shade800,
    //   onSecondary: Colors.white,
    //   error: Colors.grey.shade800,
    //   onError: Colors.white,
    //   background: Colors.grey.shade800,
    //   onBackground: Colors.white,
    //   surface: Colors.grey.shade800,
    //   onSurface: Colors.white,
    // )
  );

  ThemeData light = ThemeData.light().copyWith(
    // ignore: prefer_const_constructors
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.blue,
    ),
    // colorScheme: const ColorScheme.light(
    //   brightness: Brightness.light,
    //   primary: Colors.blue,
    //   onPrimary: Colors.white,
    //   secondary: Colors.blue,
    //   onSecondary: Colors.white,
    //   error: Colors.blue,
    //   onError: Colors.white,
    //   background: Colors.blue,
    //   onBackground: Colors.white,
    //   surface: Colors.blue,
    //   onSurface: Colors.white,
    // )  
  );

  ThemeProvider(bool isDark){
    _selectedTheme = (isDark) ? light : dark; /* aloooo cambie esto, hay que ponerlo al reves*/
  }

  Future<void> swapTheme() async {
    if (_selectedTheme == dark){
      _selectedTheme = light;
    } else {
      _selectedTheme = dark;
    }
    notifyListeners();
  }

  ThemeData? getTheme() => _selectedTheme;
}