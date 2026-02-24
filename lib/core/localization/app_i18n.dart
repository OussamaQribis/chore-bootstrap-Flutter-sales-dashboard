import 'package:flutter/widgets.dart';

class AppLanguage {
  final String code; // 'ar', 'fr', 'en', ...
  final String label; // الاسم الذي سيظهر في القائمة
  final bool isRtl; // اتجاه الكتابة

  const AppLanguage({
    required this.code,
    required this.label,
    required this.isRtl,
  });

  Locale get locale => Locale(code);
}

class AppI18n {
  // ✅ غيّر هنا فقط لإضافة لغة جديدة
  static const List<AppLanguage> languages = [
    AppLanguage(code: 'ar', label: 'العربية', isRtl: true),
    AppLanguage(code: 'fr', label: 'Français', isRtl: false),
    // مثال لاحقًا:
    // AppLanguage(code: 'en', label: 'English', isRtl: false),
  ];

  // لغة افتراضية + fallback
  static const String fallbackCode = 'fr';

  static List<Locale> get supportedLocales =>
      languages.map((l) => l.locale).toList();

  static AppLanguage languageOfCode(String code) {
    return languages.firstWhere(
      (l) => l.code == code,
      orElse: () => languages.firstWhere((l) => l.code == fallbackCode),
    );
  }

  static bool isSupported(String code) => languages.any((l) => l.code == code);

  // ✅ الترجمات: إضافة لغة = تضيف map جديدة هنا بنفس code
  static const Map<String, Map<String, String>> values = {
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
    },
  };
}
