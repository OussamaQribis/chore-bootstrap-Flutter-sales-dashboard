import 'package:product_sales_dashboard/features/sales/domain/models/sales_report.dart';
import 'package:product_sales_dashboard/features/sales/domain/repositories/sales_repository.dart';

class ApiSalesRepository implements SalesRepository {
  final String baseUrl;

  ApiSalesRepository({required this.baseUrl});

  @override
  Future<SalesReport> fetchSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // لاحقًا هنا ستضع كود استدعاء الـ API (http/dio)
    // مثال:
    // GET /sales/report?startDate=...&endDate=...
    throw UnimplementedError(
      'API repository is not implemented yet. '
      'Use LocalSalesRepository for now.',
    );
  }
}
