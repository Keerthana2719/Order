class Orderss {
  final int orderID;
  final String customerName;
  final double totalAmount;
  final DateTime dateTime;

  Orderss({
    required this.orderID,
    required this.customerName,
    required this.totalAmount,
    required this.dateTime,
  });

  factory Orderss.fromJson(Map<String, dynamic> json) {
    return Orderss(
      orderID: json['OrderID'], // Ensure the server returns 'OrderID'
      customerName: json['customerName'],
      totalAmount: json['totalAmount'],
      dateTime: DateTime.parse(json['orderDateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
