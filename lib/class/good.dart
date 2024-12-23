// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:prj3/responsive/res.dart';
// import 'package:prj3/screen/cart.dart';
// import 'package:prj3/screen/customer/cust%20page.dart';
// import 'package:prj3/screen/order/class/model%20o.dart';
// import 'package:prj3/screen/order/class/product%20display%20service.dart';
// import 'package:prj3/screen/order/class/service.dart';
// // import 'package:carousel_slider/carousel_slider.dart';

// import 'package:prj3/screen/order/desktop.dart';
// import 'package:prj3/screen/product/class/model.dart';
// import 'package:prj3/screen/product/prdct%20page.dart';

// class Mymobile extends StatefulWidget {
//   const Mymobile({super.key});

//   @override
//   _MymobileState createState() => _MymobileState();
// }

// class _MymobileState extends State<Mymobile> {
//   bool showSaveOrderButton = false;

//   late Future<ProductResponse> futureProductResponse;
//   List<String> customerNames = [];
//   String? selectedName;
//   List<int> productQuantities = [];
//   List<Map<String, dynamic>> orderDetails = [];
//   List<Orderss> ordersList = [];
//   List<Product> filteredProducts = []; // To store filtered products

//   double totalAmount = 0.0;
//   final OrderDetailsService orderDetailsService =
//       OrderDetailsService(baseUrl: "https://localhost:7193");

//   List<int> availableStocks = [];
//   List<Product> cartItems = []; // Shared cart list

//   // List of colors to cycle through
//   final colors = [
//     Colors.red,
//     Colors.blue,
//     Colors.green,
//     Colors.yellow,
//     Colors.purple,
//     Colors.orange,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     futureProductResponse = fetchProducts();
//     fetchCustomerNames();
//     // allProducts = products;
//     fetchProducts();

//     filteredProducts = allProducts;
//   }

//   Future<ProductResponse> fetchProducts() async {
//     final response = await http.get(
//       Uri.parse("https://localhost:7193/api/Customer/getAllProducts"),
//     );

//     if (response.statusCode == 200) {
//       final productResponse =
//           ProductResponse.fromJson(jsonDecode(response.body));
//       productQuantities = List<int>.filled(productResponse.products.length, 0);
//       availableStocks =
//           List<int>.from(productResponse.products.map((p) => p.stock));
//       return productResponse;
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   Future<void> fetchCustomerNames() async {
//     final url =
//         Uri.parse("https://localhost:7193/api/Customer/getCustomerNames");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         customerNames = List<String>.from(data['customerNames']);
//       });
//     } else {
//       print('Failed to load customer names');
//     }
//   }

//   void handlePlaceOrder(List<Product> products) {
//     setState(() {
//       showSaveOrderButton = true;
//       orderDetails.clear();
//       totalAmount = 0;

//       for (int i = 0; i < products.length; i++) {
//         if (productQuantities[i] > 0) {
//           final product = products[i];

//           // Safely parse or cast price
//           final price = product.price is String
//               ? double.tryParse(product.price as String) ?? 0.0
//               : product.price as double;

//           // Safely cast quantity
//           final quantity = productQuantities[i] as int;

//           // Calculate total
//           final total = price * quantity;

//           // Update total amount
//           totalAmount += total;

//           // Add to order details
//           orderDetails.add({
//             'productId': product.pId ?? '0',
//             'productName': product.name,
//             'quantity': quantity,
//             'price': price,
//             'stock': product.stock,
//             'total': total,
//           });

//           // Update stock by subtracting the ordered quantity
//           availableStocks[i] -= quantity;
//         }
//       }
//     });
//   }

//   void saveOrderToServer() async {
//     if (orderDetails.isEmpty || selectedName == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text(
//                 'Please select a customer and add products to the order.')),
//       );
//       return;
//     }

//     try {
//       final completeOrder = {
//         "customerName": selectedName,
//         "totalAmount": totalAmount,
//         "orderDateTime": DateTime.now().toIso8601String(),
//         "orderDetails": orderDetails.map((order) {
//           return {
//             "productId": order['productId'],
//             "Product_Name": order['productName'],
//             "quantity": order['quantity'],
//             "price": order['price'],
//             "total": order['total']
//           };
//         }).toList(),
//       };

//       final response = await http.post(
//         Uri.parse("https://localhost:7193/api/Customer/saveCompleteOrder"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(completeOrder),
//       );
//       final jsonResponse = jsonDecode(response.body);

//       final newOrderID = jsonResponse['orderID'];
//       if (response.statusCode == 200) {
//         final newOrder = Orderss(
//           orderID: newOrderID,
//           customerName: selectedName!,
//           totalAmount: totalAmount,
//           dateTime: DateTime.now(),
//         );

//         setState(() {
//           ordersList.add(newOrder);
//           orderDetails.clear();
//           totalAmount = 0;
//           selectedName = null;
//           productQuantities = List<int>.filled(availableStocks.length, 0);
//           showSaveOrderButton = false; // Reset Save Order button visibility
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Order saved successfully!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save order: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   void addToCart(Product product) {
//     setState(() {
//       cartItems.add(product); // Add product to cart
//       filteredProducts
//           .remove(product); // Remove product from the available list
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${product.name} added to cart')),
//     );
//   }

//   void updateQuantity(int index, {required bool isIncrement}) {
//     setState(() {
//       if (isIncrement) {
//         if (productQuantities[index] < availableStocks[index]) {
//           productQuantities[index]++;
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Insufficient stock available'),
//             ),
//           );
//         }
//       } else {
//         if (productQuantities[index] > 0) {
//           productQuantities[index]--;
//         }
//       }
//     });
//   }

//   List<String> imgList = [
//     "assets/lipstick.jpg",
//     "assets/shose.jpg",
//     "assets/jewellery.jpg"
//   ];

//   int _current = 0;

//   String searchQuery = ''; // Holds the search input
//   TextEditingController searchController = TextEditingController();
//   List<Product> allProducts = []; // To store all products

//   void filterProducts(String query) {
//     setState(() {
//       searchQuery = query.trim().toLowerCase();
//       filteredProducts = allProducts
//           .where((product) => product.name
//               .toLowerCase()
//               .contains(searchQuery)) // Filter products
//           .toList()
//         ..sort((a, b) => a.name.compareTo(b.name)); // Sort alphabetically
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentwidth = MediaQuery.of(context).size.width;
//     final isDesktop = currentwidth > 800;
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 189, 217, 240),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 189, 217, 240),
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.deepOrange,
//             )),
//         titleSpacing: 100,
//         title: Text(" Products"),
//         titleTextStyle: const TextStyle(
//             color: Colors.indigo, fontSize: 22, fontWeight: FontWeight.bold),
//         actions: [
//           IconButton(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text("Select Your Name"),
//                     content: DropdownButton<String>(
//                       value: selectedName,
//                       isExpanded: true,
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedName = newValue!;
//                         });
//                         Navigator.pop(context);
//                       },
//                       items: customerNames
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(
//                             value,
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.w600),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 },
//               );
//             },
//             icon: Icon(
//               Icons.person,
//               color: Colors.deepOrange,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.shopping_cart,
//               color: Colors.deepOrange,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CartPage(cartItems: cartItems),
//                 ),
//               );
//             },
//           ),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.more_vert, color: Colors.deepOrange),
//             color: Colors
//                 .pink, // Set pink background color for the entire PopupMenu

//             onSelected: (value) {
//               if (value == 'Customer') {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => Customerr()));
//               } else if (value == 'Product') {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => Producttt()));
//               } else if (value == 'Order') {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const Response(
//                         mobileBody: Mymobile(),
//                         desktopBody: Mydesktop(),
//                       ),
//                     ));
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'Customer',
//                 child: Text(
//                   'Customer',
//                   style: TextStyle(color: Colors.black, fontSize: 17),
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'Product',
//                 child: Text('Product',
//                     style: TextStyle(color: Colors.black, fontSize: 17)),
//               ),
//               const PopupMenuItem(
//                 value: 'Order',
//                 child: Text('Order',
//                     style: TextStyle(color: Colors.black, fontSize: 17)),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
//         child: Stack(children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   hintText: 'Search for a product...',
//                   hintStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.italic),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   prefixIcon: Icon(Icons.search),
//                 ),
//                 onChanged: (value) {
//                   filterProducts(value);
//                 },
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               // CarouselSlider(
//               //   options: CarouselOptions(
//               //     aspectRatio: 25 / 9,
//               //     autoPlay: true,
//               //     enlargeCenterPage: true,
//               //     onPageChanged: (index, reason) {
//               //       setState(() {
//               //         _current = index;
//               //       });
//               //     },
//               //   ),
//               //   items: imgList
//               //       .map((item) => Container(
//               //             child: Center(
//               //               child: Image.asset(
//               //                 item,
//               //                 fit: BoxFit.cover,
//               //                 width: MediaQuery.of(context).size.width,
//               //               ),
//               //             ),
//               //           ))
//               //       .toList(),
//               // ),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: imgList.map((url) {
//               //     int index = imgList.indexOf(url);
//               //     return Container(
//               //       width: 8.0,
//               //       height: 8.0,
//               //       margin:
//               //           EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//               //       decoration: BoxDecoration(
//               //         shape: BoxShape.circle,
//               //         color:
//               //             _current == index ? Colors.blueAccent : Colors.grey,
//               //       ),
//               //     );
//               //   }).toList(),
//               // ),
//               const SizedBox(height: 15),

//               const Text(
//                 "SHOP",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 15),
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

//                     // Update allProducts if not already set
//                     if (allProducts.isEmpty) {
//                       allProducts = snapshot.data!.products;
//                       filteredProducts =
//                           allProducts; // Initialize filteredProducts
//                     }

//                     // Use the filteredProducts list
//                     return GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2, // Number of columns
//                         crossAxisSpacing: 15.0, // Spacing between columns
//                         mainAxisSpacing: 15.0, // Spacing between rows
//                         childAspectRatio: 2 / 2, // Adjusted for medium size
//                       ),
//                       padding: const EdgeInsets.all(10.0),
//                       itemCount: filteredProducts.length,
//                       itemBuilder: (context, index) {
//                         final product = filteredProducts[index];
//                         // final containerColor = colors[index % colors.length];

//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(25),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blue.withOpacity(0.9),
//                                 spreadRadius: 3,
//                                 blurRadius: 5,
//                                 offset: const Offset(1, 1),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Product ID : ${product.pId}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     const SizedBox(height: 9),
//                                     Text("Product Name : ${product.name}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     const SizedBox(height: 9),
//                                     Text("Price : \$${product.price}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     const SizedBox(height: 9),
//                                     Text("Stock : ${availableStocks[index]}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     const SizedBox(height: 9),
//                                     Row(
//                                       children: [
//                                         const Text("Quantity :",
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
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const SizedBox(), // This keeps the left side empty
//                                         IconButton(
//                                           onPressed: () {
//                                             addToCart(product);
//                                           },
//                                           icon: const Icon(
//                                             Icons.shopping_cart,
//                                             color: Colors.green,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
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
//             ],
//           ),
//           // Add the Floating Action Button (FAB) here
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: FloatingActionButton(
//               onPressed: () {
//                 if (futureProductResponse != null) {
//                   futureProductResponse.then((response) {
//                     handlePlaceOrder(response.products);
//                   });
//                 }
//               },
//               // backgroundColor: Colors.black,
//               child: Icon(
//                 Icons.shopping_cart,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           if (orderDetails.isNotEmpty) ...[
//             const Text(
//               "Order Details",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Table(
//               border: TableBorder.all(),
//               children: [
//                 const TableRow(
//                   decoration: BoxDecoration(
//                       color: Colors.yellow), // Header background color
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Product ID",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Product Name",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Quantity",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Price",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//                 ...orderDetails.map((order) {
//                   return TableRow(
//                     decoration: BoxDecoration(
//                         color: Colors.pink[100]), // Data background color
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(order['productId'].toString()),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(order['productName']),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(order['quantity'].toString()),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('\$${order['total']}'),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             )
//           ],
//           const SizedBox(height: 20),
//           if (showSaveOrderButton) ...[
//             Center(
//               child: ElevatedButton(
//                 onPressed: saveOrderToServer,
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.indigo, // Text color
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 25, vertical: 25), // Button size
//                 ),
//                 child: const Text(
//                   'Save Order',
//                   style: TextStyle(color: Colors.white), // Button text color
//                 ),
//               ),
//             ),
//           ],
//           const SizedBox(height: 20),
//           if (ordersList.isNotEmpty) ...[
//             const Text(
//               "Saved Orders",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Table(
//               border: TableBorder.all(),
//               children: [
//                 const TableRow(
//                   decoration: BoxDecoration(color: Colors.yellow),
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Order ID",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Customer Name",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Total Amount",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         "Date & Time",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//                 ...ordersList.map((order) {
//                   return TableRow(
//                     decoration: BoxDecoration(color: Colors.pink[100]),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(order.orderID.toString()),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(order.customerName),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child:
//                             Text('\$${order.totalAmount.toStringAsFixed(2)}'),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(order.dateTime.toString()),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//           ]
//         ]),
//       ),
//     );
//   }
// }
