import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:product_sales_dashboard/core/localization/app_localizations.dart';
import 'package:product_sales_dashboard/core/localization/locale_controller.dart';
import 'package:product_sales_dashboard/features/sales/domain/repositories/sales_repository.dart';
import 'package:product_sales_dashboard/features/sales/presentation/pages/sales_dashboard_page.dart';

class MyApp extends StatelessWidget {
  final SalesRepository repository;
  final LocaleController localeController;
  const MyApp({
    super.key,
    required this.repository,
    required this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Product Sales Dashboard',
          theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),

          // ✅ اللغة الحالية Langue actuelle
          locale: localeController.locale,

          // ✅ اللغات المدعومة Langues prises en charge
          supportedLocales: AppLocalizations.supportedLocales,

          // ✅ Delegates الرسمية + Delegate الخاص بنا Délégués officiels + Notre délégué
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: SalesDashboardPage(
            repository: repository,
            localeController: localeController,
          ),
        );
      },
    );
  }
}
