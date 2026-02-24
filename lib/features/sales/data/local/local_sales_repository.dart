import 'package:product_sales_dashboard/features/sales/domain/models/product.dart';
import 'package:product_sales_dashboard/features/sales/domain/models/product_sales_stat.dart';
import 'package:product_sales_dashboard/features/sales/domain/models/sale_record.dart';
import 'package:product_sales_dashboard/features/sales/domain/models/sales_report.dart';
import 'package:product_sales_dashboard/features/sales/domain/repositories/sales_repository.dart';

class LocalSalesRepository implements SalesRepository {
  final List<Product> _products = const [
    Product(id: 'p1', name: 'iPhone 15', price: 1200),
    Product(id: 'p2', name: 'Samsung S24', price: 1100),
    Product(id: 'p3', name: 'AirPods Pro', price: 280),
    Product(id: 'p4', name: 'Apple Watch', price: 450),
    Product(id: 'p5', name: 'Gaming Mouse', price: 75),
    Product(id: 'p6', name: 'Mechanical Keyboard', price: 130),
    Product(id: 'p7', name: 'USB-C Charger', price: 35),
    Product(id: 'p8', name: 'Power Bank', price: 60),
  ];

  final List<SaleRecord> _sales = [
    // يناير 2026
    SaleRecord(productId: 'p1', quantity: 2, soldAt: DateTime(2026, 1, 2)),
    SaleRecord(productId: 'p2', quantity: 1, soldAt: DateTime(2026, 1, 3)),
    SaleRecord(productId: 'p3', quantity: 5, soldAt: DateTime(2026, 1, 5)),
    SaleRecord(productId: 'p7', quantity: 10, soldAt: DateTime(2026, 1, 7)),
    SaleRecord(productId: 'p8', quantity: 4, soldAt: DateTime(2026, 1, 8)),
    SaleRecord(productId: 'p5', quantity: 3, soldAt: DateTime(2026, 1, 10)),
    SaleRecord(productId: 'p6', quantity: 2, soldAt: DateTime(2026, 1, 12)),
    SaleRecord(productId: 'p4', quantity: 1, soldAt: DateTime(2026, 1, 15)),
    SaleRecord(productId: 'p7', quantity: 6, soldAt: DateTime(2026, 1, 18)),
    SaleRecord(productId: 'p3', quantity: 3, soldAt: DateTime(2026, 1, 20)),
    SaleRecord(productId: 'p1', quantity: 1, soldAt: DateTime(2026, 1, 22)),
    SaleRecord(productId: 'p8', quantity: 2, soldAt: DateTime(2026, 1, 25)),

    // فبراير 2026
    SaleRecord(productId: 'p2', quantity: 4, soldAt: DateTime(2026, 2, 1)),
    SaleRecord(productId: 'p3', quantity: 2, soldAt: DateTime(2026, 2, 2)),
    SaleRecord(productId: 'p4', quantity: 3, soldAt: DateTime(2026, 2, 4)),
    SaleRecord(productId: 'p5', quantity: 1, soldAt: DateTime(2026, 2, 6)),
    SaleRecord(productId: 'p6', quantity: 4, soldAt: DateTime(2026, 2, 9)),
    SaleRecord(productId: 'p7', quantity: 8, soldAt: DateTime(2026, 2, 10)),
    SaleRecord(productId: 'p8', quantity: 5, soldAt: DateTime(2026, 2, 12)),
    SaleRecord(productId: 'p1', quantity: 2, soldAt: DateTime(2026, 2, 14)),
    SaleRecord(productId: 'p2', quantity: 3, soldAt: DateTime(2026, 2, 16)),
    SaleRecord(productId: 'p3', quantity: 1, soldAt: DateTime(2026, 2, 17)),
    SaleRecord(productId: 'p7', quantity: 7, soldAt: DateTime(2026, 2, 19)),
    SaleRecord(productId: 'p4', quantity: 1, soldAt: DateTime(2026, 2, 20)),
    SaleRecord(productId: 'p5', quantity: 2, soldAt: DateTime(2026, 2, 21)),
    SaleRecord(productId: 'p6', quantity: 1, soldAt: DateTime(2026, 2, 22)),
  ];

  @override
  Future<SalesReport> fetchSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // محاكاة بسيطة لتأخير الشبكة (اختياري)
    await Future.delayed(const Duration(milliseconds: 300));

    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final normalizedEnd = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
      999,
    );

    final totalsByProduct = <String, int>{for (final p in _products) p.id: 0};

    for (final sale in _sales) {
      final inRange =
          !sale.soldAt.isBefore(normalizedStart) &&
          !sale.soldAt.isAfter(normalizedEnd);

      if (!inRange) continue;

      totalsByProduct[sale.productId] =
          (totalsByProduct[sale.productId] ?? 0) + sale.quantity;
    }

    final items = _products.map((product) {
      return ProductSalesStat(
        product: product,
        totalSold: totalsByProduct[product.id] ?? 0,
      );
    }).toList();

    return SalesReport(
      startDate: normalizedStart,
      endDate: normalizedEnd,
      items: items,
    );
  }
}
