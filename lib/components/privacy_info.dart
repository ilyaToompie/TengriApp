import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyInfo extends ConsumerWidget {
  const PrivacyInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Text(
            'С входом и регистрацией вы соглашаетесь с нашей',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 5,),
                ],
              ),
              InkWell(
                onTap: () async {
                  Uri? uri = Uri.parse("https://www.freeprivacypolicy.com/live/b316d2b0-4df7-492a-b07d-8b18fc5f4244");
                  await launchUrl(uri);
                  
                },
                child: Text('Политикой конфиденциальности', style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).primaryColor, fontSize: 15),)
              )
            ],
          )
        ],
      ),
    );
  }
}