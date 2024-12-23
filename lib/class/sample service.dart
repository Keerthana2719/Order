// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:prj3/screen/customer/cl.dart';

// class CustomerService {
//   final String baseUrl;

//   CustomerService(this.baseUrl);

//   Future<List<OrderModel>> fetchCustomerOrders() async {
//     final response = await http.get(
//         Uri.parse("https://localhost:7193/api/Customer/getCustomerOrders"));

//     if (response.statusCode == 200) {
//       List<OrderModel> orders = (json.decode(response.body) as List)
//           .map((data) => OrderModel.fromJson(data))
//           .toList();
//       return orders;
//     } else {
//       throw Exception('Failed to load customer orders');
//     }
//   }
// }
