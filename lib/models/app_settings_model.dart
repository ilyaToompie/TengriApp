import 'package:cloud_firestore/cloud_firestore.dart';

enum LicenseType { none, regular, extended }

class AppSettingsModel {
  final bool? freeCourses, topAuthors, categories, featured, tags, skipLogin, onBoarding, latestCourses, contentSecurity;
  final String? supportEmail, website, privacyUrl;
  final HomeCategory? homeCategory1, homeCategory2, homeCategory3;
  final AppSettingsSocialInfo? social;
  final AdsModel? ads;
  late final LicenseType? license;

  AppSettingsModel({
    required this.freeCourses,
    required this.topAuthors,
    required this.categories,
    required this.featured,
    required this.tags,
    required this.skipLogin,
    required this.onBoarding,
    required this.supportEmail,
    required this.website,
    required this.privacyUrl,
    required this.homeCategory1,
    required this.homeCategory2,
    required this.homeCategory3,
    required this.social,
    required this.latestCourses,
    required this.ads,
    required this.license,
    required this.contentSecurity,
  });

  factory AppSettingsModel.fromFirestore(DocumentSnapshot snap) {
    final Map d = snap.data() as Map<String, dynamic>;
    return AppSettingsModel(
      featured: d['featured'] ?? true,
      topAuthors: d['top_authors'] ?? true,
      categories: d['categories'] ?? true,
      freeCourses: d['free_courses'] ?? true,
      onBoarding: d['onboarding'] ?? true,
      skipLogin: d['skip_login'] ?? true,
      latestCourses: d['latest_courses'] ?? true,
      tags: d['tags'] ?? true,
      supportEmail: d['email'],
      privacyUrl: d['privacy_url'],
      website: d['website'],
      homeCategory1: d['category1'] != null ? HomeCategory.fromMap(d['category1']) : null,
      homeCategory2: d['category2'] != null ? HomeCategory.fromMap(d['category2']) : null,
      homeCategory3: d['category3'] != null ? HomeCategory.fromMap(d['category3']) : null,
      social: d['social'] != null ? AppSettingsSocialInfo.fromMap(d['social']) : null,
      ads: d['ads'] != null ? AdsModel.fromMap(d['ads']) : null,
      license: _getLicenseType(d['license']),
      contentSecurity: true,
    );
  }

  static LicenseType _getLicenseType(String? value) {
      return LicenseType.extended;
  }
}

class HomeCategory {
  final String id, name;

  HomeCategory({required this.id, required this.name});

  factory HomeCategory.fromMap(Map<String, dynamic> d) {
    return HomeCategory(
      id: d['id'],
      name: d['name'],
    );
  }
}

class AppSettingsSocialInfo {
  final String? telegram, instagram, tiktok, whatsapp;

  AppSettingsSocialInfo({required this.telegram, required this.instagram, required this.whatsapp, required this.tiktok});

  factory AppSettingsSocialInfo.fromMap(Map<String, dynamic> d) {
    return AppSettingsSocialInfo(
      tiktok: d['tiktok'],
      telegram: d['telegram'],
      instagram: d['instagram'],
      whatsapp: d['whatsapp'],
    );
  }
}

class AdsModel {
  final bool? isAdsEnabled, bannerEnbaled, interstitialEnabled;

  AdsModel({
    this.isAdsEnabled,
    this.bannerEnbaled,
    this.interstitialEnabled,
  });

  factory AdsModel.fromMap(Map<String, dynamic> d) {
    return AdsModel(
      isAdsEnabled: d['enabled'] ?? false,
      bannerEnbaled: d['banner'] ?? false,
      interstitialEnabled: d['interstitial'] ?? false,
    );
  }
}
