class SaleRecord {
  final String productId;
  final int quantity;
  final DateTime soldAt;

  const SaleRecord({
    required this.productId,
    required this.quantity,
    required this.soldAt,
  });
}
