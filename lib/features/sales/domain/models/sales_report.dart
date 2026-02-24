import 'package:product_sales_dashboard/features/sales/domain/models/product_sales_stat.dart';

class SalesReport {
  final DateTime startDate;
  final DateTime endDate;
  final List<ProductSalesStat> items;

  const SalesReport({
    required this.startDate,
    required this.endDate,
    required this.items,
  });

  List<ProductSalesStat> get sortedByMostSold {
    final copy = [...items];
    copy.sort((a, b) => b.totalSold.compareTo(a.totalSold));
    return copy;
  }

  List<ProductSalesStat> get sortedByLeastSold {
    final copy = [...items];
    copy.sort((a, b) => a.totalSold.compareTo(b.totalSold));
    return copy;
  }

  int get totalUnitsSold {
    return items.fold<int>(0, (sum, item) => sum + item.totalSold);
  }

  int get productsCount => items.length;

  int get productsWithSalesCount {
    return items.where((e) => e.totalSold > 0).length;
  }

  List<ProductSalesStat> topProducts({int limit = 5}) {
    final sorted = sortedByMostSold;
    return sorted.take(limit).toList();
  }

  List<ProductSalesStat> bottomProducts({int limit = 5}) {
    final sorted = sortedByLeastSold;
    return sorted.take(limit).toList();
  }
}
