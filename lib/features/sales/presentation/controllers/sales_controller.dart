import 'package:flutter/material.dart';
import 'package:product_sales_dashboard/features/sales/domain/models/sales_report.dart';
import 'package:product_sales_dashboard/features/sales/domain/repositories/sales_repository.dart';

class SalesController extends ChangeNotifier {
  final SalesRepository repository;

  SalesController({required this.repository}) {
    final now = DateTime.now();
    selectedRange = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
  }

  late DateTimeRange selectedRange;
  SalesReport? report;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadReport() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      report = await repository.fetchSalesReport(
        startDate: selectedRange.start,
        endDate: selectedRange.end,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setDateRange(DateTimeRange range) async {
    selectedRange = range;
    await loadReport();
  }
}
