import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lms_app/mixins/user_mixin.dart';
import '../../../configs/features_config.dart';
import '../../../providers/app_settings_provider.dart';
import '../../../providers/user_data_provider.dart';
import '../../auth/delete_account.dart';
import '../../../components/languages.dart';
import '../../../services/app_service.dart';
import '../../../services/notification_service.dart';
import '../../../theme/theme_provider.dart';
import '../../../utils/logout_dialog.dart';
import '../../../utils/next_screen.dart';

class AppSettings extends ConsumerWidget with UserMixin {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool notificationEnbaled = ref.watch(nProvider);
    final setttings = ref.watch(appSettingsProvider);
    final user = ref.watch(userDataProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: const Text(
            'settings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
        ),





        


        ListTile(
          leading: Icon(notificationEnbaled ? LineIcons.bell : LineIcons.bellSlash),
          title: const Text('notifications').tr(),
          trailing: Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.onSecondary,
            value: notificationEnbaled,
            onChanged: (value) => NotificationService().handleSubscription(context, value, ref),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('dark-mode').tr(),
          trailing: Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.onSecondary,
            value: ref.watch(themeProvider).isDarkMode,
            onChanged: (value) => ref.read(themeProvider.notifier).changeTheme(value),
          ),
        ),
        Visibility(
          visible: isMultilanguageEnbled,
          child: Column(
            children: [
              const Divider(),
              ListTile(
                title: const Text('language').tr(),
                leading: const Icon(LineIcons.language),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () => NextScreen.openBottomSheet(context, const Languages()),
              ),
            ],
          ),
        ),
        /*const Divider(),
        ListTile(
          title: const Text('privacy-policy').tr(),
          leading: const Icon(LineIcons.lock),
          trailing: const Icon(FeatherIcons.chevronRight),
          onTap: () => AppService().openLinkWithCustomTab(setttings?.privacyUrl ?? ''),
        ),*/
        
        const Divider(),
        ListTile(
          title: const Text('rate-app').tr(),
          leading: const Icon(LineIcons.star),
          trailing: const Icon(FeatherIcons.chevronRight),
          onTap: () => AppService().launchAppReview(context),
        ),
        Visibility(
          visible: user != null,
          child: Column(
            children: [
              const Divider(),
              ListTile(
                title: const Text('account-control').tr(),
                leading: const Icon(LineIcons.userCog),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () => NextScreen.iOS(context, const DeleteAccount()),
              ),
              const Divider(),
              ListTile(
                title: const Text('logout').tr(),
                leading: const Icon(FeatherIcons.logOut),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () => openLogoutDialog(context, () => handleLogout(context, ref: ref)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 20),
          child: const Text(
            'social',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
        ),
       
        Visibility(
          visible: setttings?.social?.telegram != null,
          child: Column(
            children: [
              ListTile(
                title: const Text('telegram').tr(),
                leading: const Icon(LineIcons.telegram),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () => AppService().openLink(setttings!.social!.telegram!),
              ),
              const Divider(),
            ],
          ),
        ),
        Visibility(
          visible: setttings?.social?.whatsapp != null,
          child: Column(
            children: [
              ListTile(
                title: const Text('Whatsapp').tr(),
                leading: const Icon(LineIcons.whatSApp),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () => AppService().openLink(setttings!.social!.whatsapp!),
              ),
              const Divider(),
            ],
          ),
        ),
        Visibility(
          visible: setttings?.social?.instagram != null,
          child: ListTile(
            title: const Text('instagram').tr(),
            leading: const Icon(FeatherIcons.instagram),
            trailing: const Icon(FeatherIcons.chevronRight),
            onTap: () => AppService().openLink(setttings!.social!.instagram!),
          ),
        ),
      ],
    );
  }
}
