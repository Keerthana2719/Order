class Cusstomer {
  String message;
  List<Customer> customers;

  Cusstomer({
    required this.message,
    required this.customers,
  });

  factory Cusstomer.fromJson(Map<String, dynamic> json) => Cusstomer(
        message: json["message"],
        customers: List<Customer>.from(
            json["customers"].map((x) => Customer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "customers": List<dynamic>.from(customers.map((x) => x.toJson())),
      };
}

class Customer {
  String id;
  String name;
  String city;
  String phone;

  Customer({
    required this.id,
    required this.name,
    required this.city,
    required this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        city: json["city"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city,
        "phone": phone,
      };
}
