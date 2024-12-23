import 'dart:convert';
import 'package:http/http.dart' as http;

class CusttomerService {
  final String baseUrl = "https://localhost:7193/api/Customer/updateCustomer";

  Future<bool> updateCustomer(
      String id, String name, String city, String phone) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "name": name,
          "city": city,
          "phone": phone,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to update customer: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating customer: $e");
      return false;
    }
  }
}
