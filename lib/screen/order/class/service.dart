import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prj3/screen/order/class/mode%20p.dart';

class OrderDetailsService {
  final String baseUrl;

  OrderDetailsService({required this.baseUrl});

  Future<bool> addOrderDetails(List<OrderDetails> orders) async {
    final url =
        Uri.parse("https://localhost:7193/api/Customer/saveCompleteOrder");
    try {
      final payload = {
        'OrderDetails': orders.map((order) => order.toJson()).toList(),
      };
      print("Sending payload: ${jsonEncode(payload)}");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error from server: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
