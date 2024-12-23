// class Product {
//   int? id;
//   String name;
//   int price;
//   int discount;
//   int stock;

//   Product({
//     this.id,
//     required this.name,
//     required this.price,
//     required this.discount,
//     required this.stock,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["Id"],
//         name: json["Name"],
//         price: json["Price"],
//         discount: json["Discount"],
//         stock: json["Stock"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Id": id,
//         "Name": name,
//         "Price": price,
//         "Discount": discount,
//         "Stock": stock,
//       };
// }

class Product {
  int pId;
  String name;
  String price;
  int discount;
  int stock;

  Product({
    required this.pId,
    required this.name,
    required this.price,
    required this.discount,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        pId: json["p_id"],
        name: json["name"],
        price: json["price"],
        discount: json["discount"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "p_id": pId,
        "name": name,
        "price": price,
        "discount": discount,
        "stock": stock,
      };
}
