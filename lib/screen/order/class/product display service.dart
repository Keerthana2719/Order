import 'package:prj3/screen/product/class/model.dart';

class ProductResponse {
  final String message;
  final List<Product> products;

  ProductResponse({required this.message, required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      message: json['message'],
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}
