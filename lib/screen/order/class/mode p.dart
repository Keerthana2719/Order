class OrderDetails {
  final int productId;
  final String productName;
  final int quantity;
  final double amount;
  final double total;

  OrderDetails({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.total,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      amount: json['amount'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'amount': amount,
      'total': total,
    };
  }
}
