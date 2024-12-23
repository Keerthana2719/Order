import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http;
import 'package:prj3/screen/customer/class/model.dart';

/// Function to send a POST request to create a new customer
Future<http.Response> postdetails(Customer c1) async {
  // Map containing customer details
  Map<String, String> mappedData = {
    //"cust_id": c1.NewID.toString(),
    "cust_name": c1.name.toString(),
    "cust_city": c1.city.toString(),
    "cust_ph": c1.ph.toString(),
    "cust_id": c1.NewID.toString(),
  };

  // API endpoint URL
  var url = Uri.parse("https://localhost:7193/api/Customer/createCustomer");

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
