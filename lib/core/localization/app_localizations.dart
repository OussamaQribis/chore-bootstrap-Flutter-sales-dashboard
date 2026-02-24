import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = <Locale>[Locale('ar'), Locale('fr')];

  static AppLocalizations of(BuildContext context) {
    final value = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return value ?? const AppLocalizations(Locale('fr'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String t(String key) {
    final lang = locale.languageCode;
    return _values[lang]?[key] ?? _values['fr']?[key] ?? key;
  }

  static const Map<String, Map<String, String>> _values = {
    'ar': {
      'app_title': 'مبيعات المنتجات',
      'tab_products': 'المنتجات',
      'tab_most': 'الأكثر',
      'tab_least': 'الأقل',
      'tab_compare': 'مقارنة',
      'tooltip_refresh': 'تحديث',
      'pick_range_help': 'اختر الفترة الزمنية',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'save': 'حفظ',
      'total_units': 'إجمالي الوحدات المباعة',
      'active_products': 'المنتجات النشطة',
      'most_sold': 'الأكثر مبيعًا',
      'least_sold': 'الأقل مبيعًا',
      'sold': 'المباع',
      'price': 'السعر',
      'units_sold': 'عدد الوحدات المباعة',
      'no_data': 'لا توجد بيانات',
      'error_prefix': 'خطأ:',
      'lang_ar': 'العربية',
      'lang_fr': 'Français',
    },
    'fr': {
      'app_title': 'Ventes des produits',
      'tab_products': 'Produits',
      'tab_most': 'Top',
      'tab_least': 'Flop',
      'tab_compare': 'Comparaison',
      'tooltip_refresh': 'Rafraîchir',
      'pick_range_help': 'Choisir la période',
      'cancel': 'Annuler',
      'confirm': 'Confirmer',
      'save': 'Enregistrer',
      'total_units': 'Total des unités vendues',
      'active_products': 'Produits actifs',
      'most_sold': 'Meilleure vente',
      'least_sold': 'Moins vendu',
      'sold': 'Vendu',
      'price': 'Prix',
      'units_sold': 'Unités vendues',
      'no_data': 'Aucune donnée',
      'error_prefix': 'Erreur :',
      'lang_ar': 'العربية',
      'lang_fr': 'Français',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
