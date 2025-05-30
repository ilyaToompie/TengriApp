import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/configs/app_assets.dart';
import 'package:lms_app/configs/app_config.dart';
import 'package:lms_app/iAP/iap_config.dart';
import 'package:lms_app/iAP/iap_screen.dart';
//import '../../../../iAP/iap_config.dart';
//import '../../../../iAP/iap_screen.dart';
import 'package:lms_app/screens/check_homework/homework_course_screen.dart';
import 'package:lms_app/screens/tabs/profile_tab/user_roles_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../components/user_avatar.dart';
import '../../../mixins/user_mixin.dart';
import '../../../models/user_model.dart';
import '../../edit_profile.dart';
import '../../../utils/next_screen.dart';

class UserInfo extends StatelessWidget with UserMixin {
  const UserInfo({super.key, required this.user, required this.ref});

  final UserModel user;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          onTap: () => NextScreen.openBottomSheet(context, EditProfile(user: user), maxHeight: 0.80),
          title: Text(
            user.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.email),
            ],
          ),
          leading: UserAvatar(imageUrl: user.imageUrl, radius: 50, iconSize: 25),
          trailing: const Icon(
            FeatherIcons.edit3,
            size: 20,
          ),
        ),
        UserRolesWidget(user: user, ref: ref,),
        if (user.role!.contains('author') || user.role!.contains('admin'))
        Column(
          children: [
            ListTile(title: Text("homework_solutions_title".tr()), 
            leading: const Icon(FeatherIcons.bookOpen),                 
            trailing: const Icon(FeatherIcons.chevronRight),
            onTap: () {
              NextScreen.iOS(context, HomeworkCourseScreen(user: user,));
            },
            ),
            ListTile(title: Text("open_admin_panel_title".tr()), 
            leading: const Icon(Icons.web),                 
            trailing: const Icon(FeatherIcons.chevronRight),
            onTap: () async {
            if (!await launchUrl(AppConfig.webAdminURL)) {
                throw Exception('Could not launch $AppConfig.webAdminURL');
            }   
            },
            ),
          ],
        ),
        Consumer(
          builder: (context, ref, child) {
            if (IAPConfig.iAPEnabled) {
              return InkWell(
                child: user.subscription == null ? _noSubscriptionContainer(context) : _subscriptionContainer(context),
                onTap: () => NextScreen.openBottomSheet(context, const IAPScreen(), isDismissable: false),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        )
      ],
    );
  }

  Container _subscriptionContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 0.3, color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
          minVerticalPadding: 20,
          leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColor, child: Image.asset(premiumImage, height: 20, width: 20)),
          title: Text(
            user.subscription!.plan,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          subtitle: UserMixin.isExpired(user)
              ? const Text(
                  'expired',
                  style: TextStyle(color: Colors.redAccent),
                ).tr()
              : RichText(
                  text: TextSpan(
                      text: 'active'.tr().padRight(8),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blueAccent,
                          ),
                      children: [
                        const TextSpan(text: '('),
                        TextSpan(
                          text: 'expire-in-days'.tr(args: [remainingDays(user).toString()]),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                        ),
                        const TextSpan(text: ')')
                      ]),
                )),
    );
  }

  Container _noSubscriptionContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 0.3, color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        trailing: const Icon(FeatherIcons.chevronRight),
        minVerticalPadding: 20,
        leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColor, child: Image.asset(premiumImage, height: 20, width: 20)),
        title: Text(
          'subscribe-to-access-features',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ).tr(),
      ),
    );
  }
}
