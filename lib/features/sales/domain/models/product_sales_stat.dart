import 'package:product_sales_dashboard/features/sales/domain/models/product.dart';

class ProductSalesStat {
  final Product product;
  final int totalSold;

  const ProductSalesStat({required this.product, required this.totalSold});
}
