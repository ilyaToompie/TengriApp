import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_settings_provider.dart';
import '../services/app_service.dart';

class PrivacyInfo extends ConsumerWidget {
  const PrivacyInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final String privacyUrl = settings?.privacyUrl ?? 'https://google.com';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Text(
            'С входом и регистрацией вы соглашаетесь на наши',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  InkWell(
                    onTap: ()=> AppService().openLinkWithCustomTab(privacyUrl),
                    child: Text('Условия предоставления услуг', style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).colorScheme.onSecondary, fontSize: 15),)
                  ),
                  const SizedBox(width: 5,),
                  const Text('и с'),
                  const SizedBox(width: 5,),
                ],
              ),
              InkWell(
                onTap: ()=> AppService().openLinkWithCustomTab(privacyUrl),
                child: Text('политикой конфиденциальности', style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).colorScheme.onSecondary, fontSize: 15),)
              )
            ],
          )
        ],
      ),
    );
  }
}