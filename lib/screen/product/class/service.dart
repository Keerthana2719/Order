import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http;
import 'package:prj3/screen/product/class/model.dart';

/// Function to send a POST request to create a new customer
Future<http.Response> postdetailss(Product c1) async {
  // Map containing customer details
  Map<String, String> mappedData = {
    "P_id": c1.pId.toString(),
    "name": c1.name.toString(),
    "price": c1.price.toString(),
    "discount": c1.discount.toString(),
    "stock": c1.stock.toString(),
  };

  // API endpoint URL
  var url = Uri.parse("https://localhost:7193/api/Customer/createProduct");

  try {
    // Perform the POST request
    http.Response response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // Set Content-Type to JSON
      body: jsonEncode(mappedData), // Convert the map to JSON string
    );

    // Print response for debugging
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return response;
  } catch (e) {
    // Handle any exceptions
    print('Error occurred: $e');
    rethrow; // Rethrow the exception to handle it elsewhere if needed
  }
}
