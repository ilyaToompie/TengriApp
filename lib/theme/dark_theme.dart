import 'dart:io';
import 'package:flutter/material.dart';
import '../configs/app_config.dart';
import 'text_themes.dart';
// import '../configs/font_config.dart';
// import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(onSecondary: Colors.amber, onPrimary: Colors.amber, secondary: Color.fromARGB(115, 159, 159, 159)), 
  useMaterial3: true,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: AppConfig.appThemeColor,
  textTheme: Platform.isIOS ? textThemeiOS : textThemeDefault,
  
  dividerTheme: DividerThemeData(color: Colors.blueGrey.shade900),
    appBarTheme: const AppBarTheme(
    
    shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(32) 

              )
            ),
    backgroundColor: AppConfig.appThemeColor,
    foregroundColor: Colors.white,
    
  ),
);
