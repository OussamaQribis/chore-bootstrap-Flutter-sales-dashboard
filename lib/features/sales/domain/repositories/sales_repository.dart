import 'package:product_sales_dashboard/features/sales/domain/models/sales_report.dart';

abstract class SalesRepository {
  Future<SalesReport> fetchSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  });
}
