import 'package:flutter/material.dart';
import 'package:product_sales_dashboard/core/localization/app_i18n.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  AppLanguage get currentLanguage =>
      AppI18n.languageOfCode(_locale.languageCode);

  bool get isRtl => currentLanguage.isRtl;

  void setLocale(Locale locale) {
    if (!AppI18n.isSupported(locale.languageCode)) return;
    if (_locale.languageCode == locale.languageCode) return;

    _locale = Locale(locale.languageCode);
    notifyListeners();
  }

  void setByCode(String code) => setLocale(Locale(code));
}
