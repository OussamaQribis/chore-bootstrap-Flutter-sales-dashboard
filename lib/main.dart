import 'package:flutter/material.dart';
import 'package:product_sales_dashboard/app/app.dart';
import 'package:product_sales_dashboard/core/localization/locale_controller.dart';
import 'package:product_sales_dashboard/features/sales/data/local/local_sales_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final localeController = LocaleController();

  runApp(
    MyApp(
      repository: LocalSalesRepository(),
      localeController: localeController,
    ),
  );
}
