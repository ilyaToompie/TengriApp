import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lms_app/configs/font_config.dart';
import '../configs/app_config.dart';
import 'text_themes.dart';
// import '../configs/font_config.dart';
// import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme:  ColorScheme.light(onSecondary: Colors.amber, onPrimary: Colors.amber, primary: Colors.amber, secondary: Color.fromARGB(115, 159, 159, 159),), 
  useMaterial3: true,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: AppConfig.appThemeColor,
  
  textTheme: (Platform.isIOS ? textThemeiOS : textThemeDefault),
  fontFamily: GoogleFonts.getFont(fontFamily).fontFamily,
  appBarTheme: const AppBarTheme(
    
    
    titleTextStyle: TextStyle(color: Colors.white),
  
    backgroundColor: AppConfig.appThemeColor,
    foregroundColor: Colors.white,
    
  ),
  
  dividerTheme: DividerThemeData(color: Colors.blueGrey.shade100, thickness: 0.7),
);


