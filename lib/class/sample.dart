// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:prj3/responsive/res.dart';
// import 'package:prj3/screen/customer/cust%20page.dart';
// import 'package:prj3/screen/order/class/model%20o.dart';
// import 'package:prj3/screen/order/class/pservice%20cls.dart';
// import 'package:prj3/screen/order/class/service.dart';
// import 'package:prj3/screen/order/desktop.dart';
// import 'package:prj3/screen/product/prdct%20page.dart';

// class Mymobile extends StatefulWidget {
//   const Mymobile({super.key});

//   @override
//   _MymobileState createState() => _MymobileState();
// }

// class _MymobileState extends State<Mymobile> {
  // bool showSaveOrderButton = false;

  // late Future<ProductResponse> futureProductResponse;
  // List<String> customerNames = [];
  // String? selectedName;
  // List<int> productQuantities = [];
  // List<Map<String, dynamic>> orderDetails = [];
  // List<Orderss> ordersList = [];
  // double totalAmount = 0.0;
  // final OrderDetailsService orderDetailsService =
  //     OrderDetailsService(baseUrl: "https://localhost:7193");

  // List<int> availableStocks = [];

  // @override
  // void initState() {
  //   super.initState();
  //   futureProductResponse = fetchProducts();
  //   fetchCustomerNames();
  // }

  // Future<ProductResponse> fetchProducts() async {
  //   final response = await http.get(
  //     Uri.parse("https://localhost:7193/api/Customer/getAllProducts"),
  //   );

  //   if (response.statusCode == 200) {
  //     final productResponse =
  //         ProductResponse.fromJson(jsonDecode(response.body));
  //     productQuantities = List<int>.filled(productResponse.products.length, 0);
  //     availableStocks =
  //         List<int>.from(productResponse.products.map((p) => p.stock));
  //     return productResponse;
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

  // Future<void> fetchCustomerNames() async {
  //   final url =
  //       Uri.parse("https://localhost:7193/api/Customer/getCustomerNames");
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     setState(() {
  //       customerNames = List<String>.from(data['customerNames']);
  //     });
  //   } else {
  //     print('Failed to load customer names');
  //   }
  // }

  // void handlePlaceOrder(List<Product> products) {
  //   setState(() {
  //     showSaveOrderButton = true;

  //     orderDetails.clear();
  //     totalAmount = 0;

  //     for (int i = 0; i < products.length; i++) {
  //       if (productQuantities[i] > 0) {
  //         final product = products[i];
  //         final total = product.price * productQuantities[i];
  //         totalAmount += total;

  //         orderDetails.add({
  //           'productId': int.tryParse(product.id) ?? 0,
  //           'productName': product.name,
  //           'quantity': productQuantities[i],
  //           'price': product.price,
  //           "stock": product.stock,
  //           'total': total,
  //         });

  //         // Update stock by subtracting the ordered quantity
  //         availableStocks[i] -= productQuantities[i];
  //       }
  //     }
  //   });
  // }

  // void saveOrderToServer() async {
  //   if (orderDetails.isEmpty || selectedName == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text(
  //               'Please select a customer and add products to the order.')),
  //     );
  //     return;
  //   }

  //   try {
  //     final completeOrder = {
  //       "customerName": selectedName,
  //       "totalAmount": totalAmount,
  //       "orderDateTime": DateTime.now().toIso8601String(),
  //       "orderDetails": orderDetails.map((order) {
  //         return {
  //           "productId": order['productId'],
  //           "Product_Name": order['productName'],
  //           "quantity": order['quantity'],
  //           "price": order['price'],
  //           "total": order['total']
  //         };
  //       }).toList(),
  //     };

  //     final response = await http.post(
  //       Uri.parse("https://localhost:7193/api/Customer/saveCompleteOrder"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(completeOrder),
  //     );
  //     final jsonResponse = jsonDecode(response.body);

  //     final newOrderID = jsonResponse['orderID'];
  //     if (response.statusCode == 200) {
  //       final newOrder = Orderss(
  //         orderID: newOrderID,
  //         customerName: selectedName!,
  //         totalAmount: totalAmount,
  //         dateTime: DateTime.now(),
  //       );

  //       setState(() {
  //         ordersList.add(newOrder);
  //         orderDetails.clear();
  //         totalAmount = 0;
  //         selectedName = null;
  //         productQuantities = List<int>.filled(availableStocks.length, 0);
  //         showSaveOrderButton = false; // Reset Save Order button visibility
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Order saved successfully!')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to save order: ${response.body}')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  // void updateQuantity(int index, {required bool isIncrement}) {
  //   setState(() {
  //     if (isIncrement) {
  //       if (productQuantities[index] < availableStocks[index]) {
  //         productQuantities[index]++;
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Insufficient stock available'),
  //           ),
  //         );
  //       }
  //     } else {
  //       if (productQuantities[index] > 0) {
  //         productQuantities[index]--;
  //       }
  //     }
  //   });
  // }

//   @override
//   Widget build(BuildContext context) {
//     final currentwidth = MediaQuery.of(context).size.width;
//     final isDesktop = currentwidth > 800;
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.indigo,
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context); // Go back to the previous screen
//               },
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: Colors.white,
//               )),
//           titleSpacing: 100,
//           title: Text(" Order"),
//           titleTextStyle: TextStyle(color: Colors.white, fontSize: 19),
//           actions: [
//             PopupMenuButton<String>(
//               icon: Icon(Icons.more_vert,
//                   color: Colors.white), // Set the color of the icon
//               color: Colors
//                   .pink, // Set pink background color for the entire PopupMenu

//               onSelected: (value) {
//                 if (value == 'Customer') {
//                   Navigator.push(
//                       context, MaterialPageRoute(builder: (_) => Customerr()));
//                 } else if (value == 'Product') {
//                   Navigator.push(
//                       context, MaterialPageRoute(builder: (_) => Producttt()));
//                 } else if (value == 'Order') {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => Response(
//                           mobileBody:
//                               Mymobile(), // Replace with your mobile layout widget
//                           desktopBody:
//                               Mydesktop(), // Replace with your desktop layout widget
//                         ),
//                       ));
//                 }
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: 'Customer',
//                   child: Text(
//                     'Customer',
//                     style: TextStyle(color: Colors.black, fontSize: 17),
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: 'Product',
//                   child: Text('Product',
//                       style: TextStyle(color: Colors.black, fontSize: 17)),
//                 ),
//                 PopupMenuItem(
//                   value: 'Order',
//                   child: Text('Order',
//                       style: TextStyle(color: Colors.black, fontSize: 17)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         body: Padding(
//             padding:
//                 const EdgeInsets.only(left: 20, right: 20), // Adjust padding
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const SizedBox(height: 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 8.0),
//                     margin: const EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.blue.withOpacity(0.7),
//                           spreadRadius: 3,
//                           blurRadius: 7,
//                           offset: Offset(0, 1), // changes position of shadow
//                         ),
//                       ],
//                     ),
//                     child: DropdownButton<String>(
//                       value: selectedName,
//                       hint: const Text(
//                         'Customer Name',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       underline: SizedBox(), // Removes the underline
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedName = newValue;
//                         });
//                       },
//                       items: customerNames
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(
//                             value,
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               const Text(
//                 "Products",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Expanded(
//                 child: FutureBuilder<ProductResponse>(
//                   future: futureProductResponse,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData ||
//                         snapshot.data!.products.isEmpty) {
//                       return const Center(child: Text('No products available'));
//                     }

//                     final products = snapshot.data!.products;

//                     return GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2, // Number of columns
//                         crossAxisSpacing: 10.0, // Spacing between columns
//                         mainAxisSpacing: 10.0, // Spacing between rows
//                         childAspectRatio: 5 / 5, // Adjusted for medium size
//                       ),
//                       padding: const EdgeInsets.all(10.0),
//                       itemCount: products.length,
//                       itemBuilder: (context, index) {
//                         final product = products[index];
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             //border: Border.all(color: Colors.blue),
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blue.withOpacity(0.4),
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Top section
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Product ID: ${product.id}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     const SizedBox(height: 9),
//                                     Text(
//                                         "Price: \$${product.price.toStringAsFixed(2)}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     const SizedBox(height: 9),
//                                     Text("Stock: ${availableStocks[index]}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     const SizedBox(height: 9),
//                                     Row(
//                                       children: [
//                                         const Text("Quantity:",
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold)),
//                                         const SizedBox(width: 5),
//                                         Row(
//                                           children: [
//                                             IconButton(
//                                               icon: Icon(Icons.remove),
//                                               onPressed: () {
//                                                 updateQuantity(index,
//                                                     isIncrement: false);
//                                               },
//                                             ),
//                                             Text(productQuantities[index]
//                                                 .toString()),
//                                             IconButton(
//                                               icon: Icon(Icons.add),
//                                               onPressed: () {
//                                                 updateQuantity(index,
//                                                     isIncrement: true);
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Spacer(),
//                               // Bottom section
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.all(8.0),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(10),
//                                     bottomRight: Radius.circular(10),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   product.name,
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (futureProductResponse != null) {
//                       futureProductResponse.then((response) {
//                         handlePlaceOrder(response.products);
//                       });
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: Colors.indigo, // Text color
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 25, vertical: 25), // Button size
//                   ),
//                   child: const Text('Place Order'),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               if (orderDetails.isNotEmpty) ...[
//                 const Text(
//                   "Order Details",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Table(
//                   border: TableBorder.all(),
//                   children: [
//                     const TableRow(
//                       decoration: BoxDecoration(
//                           color: Colors.yellow), // Header background color
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Product ID",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Product Name",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Quantity",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Price",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     ...orderDetails.map((order) {
//                       return TableRow(
//                         decoration: BoxDecoration(
//                             color: Colors.pink[100]), // Data background color
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(order['productId'].toString()),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(order['productName']),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(order['quantity'].toString()),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text('\$${order['total']}'),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 )
//               ],
//               const SizedBox(height: 20),
//               if (showSaveOrderButton) ...[
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: saveOrderToServer,
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: Colors.indigo, // Text color
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 25, vertical: 25), // Button size
//                     ),
//                     child: const Text(
//                       'Save Order',
//                       style:
//                           TextStyle(color: Colors.white), // Button text color
//                     ),
//                   ),
//                 ),
//               ],
//               const SizedBox(height: 20),
//               if (ordersList.isNotEmpty) ...[
//                 const Text(
//                   "Saved Orders",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Table(
//                   border: TableBorder.all(),
//                   children: [
//                     const TableRow(
//                       decoration: BoxDecoration(color: Colors.yellow),
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Order ID",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Customer Name",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Total Amount",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Date & Time",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     ...ordersList.map((order) {
//                       return TableRow(
//                         decoration: BoxDecoration(color: Colors.pink[100]),
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(order.orderID.toString()),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(order.customerName),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                                 '\$${order.totalAmount.toStringAsFixed(2)}'),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(order.dateTime.toString()),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ]
//             ])));
//   }
// }





// class Orderss {
//   final int orderID;
//   final String customerName;
//   final double totalAmount;
//   final DateTime dateTime;

//   Orderss({
//     required this.orderID,
//     required this.customerName,
//     required this.totalAmount,
//     required this.dateTime,
//   });

//   factory Orderss.fromJson(Map<String, dynamic> json) {
//     return Orderss(
//       orderID: json['OrderID'], // Ensure the server returns 'OrderID'
//       customerName: json['customerName'],
//       totalAmount: json['totalAmount'],
//       dateTime: DateTime.parse(json['orderDateTime']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'orderID': orderID,
//       'customerName': customerName,
//       'totalAmount': totalAmount,
//       'dateTime': dateTime.toIso8601String(),
//     };
//   }
// }
