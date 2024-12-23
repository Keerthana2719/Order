import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prj3/screen/customer/class/cl.dart';
import 'dart:convert';

import 'package:prj3/screen/customer/class/dis%20model.dart';
import 'package:prj3/screen/customer/cust%20order.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerList> {
  late Future<Cusstomer> futureCustomerData;

  @override
  void initState() {
    super.initState();
    futureCustomerData = fetchCustomerData();
  }

  Future<Cusstomer> fetchCustomerData() async {
    final response = await http
        .get(Uri.parse("https://localhost:7193/api/Customer/getCustomer"));

    if (response.statusCode == 200) {
      return Cusstomer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load customer data');
    }
  }

  void _navigateToEditScreen(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCustomerScreen(
          id: customer.id,
          initialName: customer.name,
          initialCity: customer.city,
          initialPhone: customer.phone,
        ),
      ),
    );
  }

  Future<void> _deleteCustomer(String id) async {
    final response = await http.delete(
      Uri.parse("https://localhost:7193/api/Customer/deleteCustomer/$id"),
    );

    if (response.statusCode == 200) {
      setState(() {
        futureCustomerData = fetchCustomerData(); // Refresh the customer list
      });
    } else {
      // Handle error
      print('Failed to delete customer');
    }
  }

  void _viewOrders(String customerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerOrdersScreen(customerId: customerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 31, 30, 30),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_left,
              size: 30,
              color: Colors.deepOrange,
            )),
        title: const Center(
            child: Text(
          'Customer List',
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange),
        )),
      ),
      body: FutureBuilder<Cusstomer>(
        future: futureCustomerData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.customers.isEmpty) {
            return const Center(child: Text('No customers found'));
          } else {
            final customers = snapshot.data!.customers;
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.black45, // Background color of the container
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(-3, -3),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.white12,
                        offset: Offset(6, 6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                            width:
                                8.0), // Add space between avatar and cart icon
                        IconButton(
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.green),
                          onPressed: () => _viewOrders(customer.id),
                        ),
                      ],
                    ),
                    title: Text(
                      customer.name,
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'City: ${customer.city}\nPhone: ${customer.phone}',
                      style: const TextStyle(
                        color: Colors.white, // Custom subtitle color
                        fontSize: 14.0, // Font size
                        fontStyle: FontStyle.italic, // Optional italic style
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () => _navigateToEditScreen(customer),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCustomer(customer.id),
                        ),
                      ],
                    ),
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
