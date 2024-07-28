import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms_app/configs/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      logo,
      height: 55,
      width: 80 ,
    );
  }
}
