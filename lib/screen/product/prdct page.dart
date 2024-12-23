import 'package:flutter/material.dart';
import 'package:prj3/responsive/res.dart';
import 'package:prj3/screen/customer/cust%20page.dart';
import 'package:prj3/screen/order/desktop.dart';
import 'package:prj3/screen/order/mobile.dart';
import 'package:prj3/screen/product/class/model.dart';
import 'package:prj3/screen/product/class/service.dart';

class Producttt extends StatefulWidget {
  const Producttt({super.key});

  @override
  State<Producttt> createState() => _ProductttState();
}

class _ProductttState extends State<Producttt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: 500.0).animate(_controller)
      ..addListener(() => setState(() {}));
    _controller.forward();
  }

  Future<void> submitForm(BuildContext context) async {
    try {
      final newProduct = Product(
        pId: 0,
        name: nameController.text.trim(),
        price: priceController.text.trim(),
        discount: int.parse(discountController.text.trim()),
        stock: int.parse(stockController.text.trim()),
      );

      final response = await postdetailss(newProduct);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Data Submitted Successfully'),
              backgroundColor: Colors.pink),
        );
        nameController.clear();
        priceController.clear();
        discountController.clear();
        stockController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to Submit Data: ${response.body}'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 142, 176),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset("assets/pp.jpg", fit: BoxFit.cover),
          ),

          // Top Row with icons
          Positioned(
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.indigo, size: 30),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert,
                      color: Colors.indigo, size: 30),
                  color: Colors.black,
                  onSelected: (value) {
                    if (value == 'Customer') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Customerr()));
                    } else if (value == 'Product') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Producttt()));
                    } else if (value == 'Order') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Response(
                              mobileBody: Mymobile(), desktopBody: Mydesktop()),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    _buildMenuItem('Customer'),
                    _buildMenuItem('Product'),
                    _buildMenuItem('Order'),
                  ],
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.tealAccent),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ],
            ),
          ),

          // Animated Container
          Positioned(
            left: 60,
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: _animation.value,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 241, 154, 188),
                borderRadius:
                    BorderRadiusDirectional.only(topStart: Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 250, 185, 200),
                    offset: Offset(-3, -3),
                    blurRadius: 1,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Product Management",
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 25),
                      ..._buildTextFields(),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Submit Product',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      _buildTextField(controller: nameController, label: 'Product Name'),
      const SizedBox(height: 25),
      _buildTextField(
          controller: priceController,
          label: 'Price',
          inputType: TextInputType.number),
      const SizedBox(height: 25),
      _buildTextField(
          controller: discountController,
          label: 'Discount',
          inputType: TextInputType.number),
      const SizedBox(height: 25),
      _buildTextField(
          controller: stockController,
          label: 'Stock',
          inputType: TextInputType.number),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value) {
    return PopupMenuItem(
      value: value,
      child: Text(
        value,
        style: const TextStyle(color: Colors.tealAccent, fontSize: 14),
      ),
    );
  }
}
