import 'package:flutter/material.dart';

class AppConfig {

  
  // App Name
  static const String appName = 'TengriApp';

  // App Theme Color - Change Hex code <3F51B5>
  static const Color appThemeColor = Color.fromRGBO(27, 27, 27, 1);
  static const Gradient appBarGradient = LinearGradient(
                  begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Color.fromRGBO(15, 15, 15, 1),
                  Color.fromRGBO(40, 40, 40, 1),
                ]);
 
  // Android Package Name
  static const String androidPackageName = 'com.tengri.lms_app';

  // iOS App ID
  static const String iosAppID = '000000';

  static Uri webAdminURL = Uri.parse('https://tengri-app.web.app/');
}
