import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/providers/app_settings_provider.dart';

import '../configs/app_assets.dart';

class PremiumTag extends ConsumerWidget {
  const PremiumTag({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.read(appSettingsProvider)!.isTest
      ? false
      : true,
      child: Visibility(
        visible: course.price == 0
        ? false
        : true,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Image.asset(premiumImage, height: 16, width: 16, fit: BoxFit.contain)),
        ),
      ),
    );
  }
}
