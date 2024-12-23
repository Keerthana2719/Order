import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prj3/screen/customer/class/or%20model.dart';

class CustomerOrdersScreen extends StatelessWidget {
  final String customerId;

  const CustomerOrdersScreen({super.key, required this.customerId});

  Future<List<Orderrrr>> fetchCustomerOrders() async {
    final response = await http.get(Uri.parse(
        "https://localhost:7193/api/Customer/getCustomerOrders/$customerId"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((order) => Orderrrr.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load customer orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Orders'),
      ),
      body: FutureBuilder<List<Orderrrr>>(
        future: fetchCustomerOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ExpansionTile(
                    title: Text('Order ID: ${order.orderId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer: ${order.customerName}'),
                        Text(
                            'Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                        Text('Date: ${order.dateTime}'),
                      ],
                    ),
                    children: order.orderDetails.map((detail) {
                      return ListTile(
                        title: Text(detail.productName),
                        subtitle: Text(
                            'Quantity: ${detail.quantity}, Total: \$${detail.total.toStringAsFixed(2)}'),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
