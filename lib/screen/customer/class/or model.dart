class Orderrrr {
  int orderId;
  String customerName;
  int totalAmount;
  DateTime dateTime;
  List<OrderDetail> orderDetails;

  Orderrrr({
    required this.orderId,
    required this.customerName,
    required this.totalAmount,
    required this.dateTime,
    required this.orderDetails,
  });

  factory Orderrrr.fromJson(Map<String, dynamic> json) => Orderrrr(
        orderId: json["orderID"],
        customerName: json["customerName"],
        totalAmount: json["totalAmount"],
        dateTime: DateTime.parse(json["dateTime"]),
        orderDetails: List<OrderDetail>.from(
            json["orderDetails"].map((x) => OrderDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "customerName": customerName,
        "totalAmount": totalAmount,
        "dateTime": dateTime.toIso8601String(),
        "orderDetails": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
      };
}

class OrderDetail {
  int productId;
  String productName;
  int quantity;
  int amount;
  int total;

  OrderDetail({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.total,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        productId: json["product_id"],
        productName: json["product_Name"],
        quantity: json["quantity"],
        amount: json["amount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_Name": productName,
        "quantity": quantity,
        "amount": amount,
        "total": total,
      };
}
