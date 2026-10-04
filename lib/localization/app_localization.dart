import 'package:flutter/material.dart';

import '/core/app_export.dart';

class AppLocalization extends Translations {
  static List<String> get locales {
    return ['en', 'ar', 'ur'];
  }

  static Locale get locale {
    return Get.deviceLocale ?? const Locale('en');
  }

  static Locale get fallbackLocale {
    return const Locale('en');
  }

  static List<Locale> get supportedLocales {
    return locales.map((locale) => Locale(locale)).toList();
  }

  Map<String, Map<String, String>> get translations => {
    'en': {
      'seyanah': 'Seyanah',
      'initializing...': 'Initializing...',
      'premium_home_services': 'Premium Home Services',
      'dependable_expert_care': 'Dependable Expert Care',
    },
    'ar': {
      'seyanah': 'صيانة',
      'initializing...': 'جارٍ التهيئة...',
      'premium_home_services': 'خدمات منزلية متميزة',
      'dependable_expert_care': 'الرعاية المتخصصة الموثوقة',
    },
    'ur': {
      'seyanah': 'صیانہ',
      'initializing...': 'شروع ہو رہا ہے...',
      'premium_home_services': 'پریمیم ہوم سروسز',
      'dependable_expert_care': 'قابلِ اعتماد ماہرین کی دیکھ بھال',
    },
  };

  @override
  Map<String, Map<String, String>> get keys => translations;
}
