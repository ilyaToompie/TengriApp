import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lms_app/configs/font_config.dart';
import '../configs/app_config.dart';
import 'text_themes.dart';
// import '../configs/font_config.dart';
// import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(primary: Colors.amber,onSecondary: Colors.amber, onPrimary: Colors.amber, secondary: Color.fromARGB(115, 159, 159, 159),), 
  useMaterial3: true,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: AppConfig.appThemeColor,
  textTheme: Platform.isIOS ? textThemeiOS : textThemeDefault,
  fontFamily: GoogleFonts.getFont(fontFamily).fontFamily,

  

  dividerTheme: DividerThemeData(color: Colors.blueGrey.shade900),
    appBarTheme: const AppBarTheme(
    
      
    backgroundColor: AppConfig.appThemeColor,
    foregroundColor: Colors.white,

  ),
);
