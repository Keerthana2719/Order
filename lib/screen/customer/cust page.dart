import 'package:flutter/material.dart';
import 'package:prj3/responsive/res.dart';
import 'package:prj3/screen/customer/class/model.dart';
import 'package:prj3/screen/customer/class/service.dart';
import 'package:prj3/screen/customer/edit.dart';
import 'package:prj3/screen/order/desktop.dart';
import 'package:prj3/screen/order/mobile.dart';
import 'package:prj3/screen/product/prdct%20page.dart';

class Customerr extends StatefulWidget {
  const Customerr({super.key});

  @override
  State<Customerr> createState() => _HomeState();
}

class _HomeState extends State<Customerr> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void submitForm(BuildContext context) async {
    try {
      // Create a new customer object from user input without the ID
      Customer newCustomer = Customer(
        name: nameController.text.trim(),
        city: cityController.text.trim(),
        ph: int.parse(phoneController.text.trim()),
        NewID: 0, // ID is not needed, let the server handle it
      );

      // Call the postDetails function to submit the data
      var response = await postdetails(newCustomer);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success SnackBar for successful submission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data Submitted Successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the text fields and refresh the state
        setState(() {
          nameController.clear();
          cityController.clear();
          phoneController.clear();
        });
      } else {
        // Show failure SnackBar for other status codes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to Submit Data: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle exceptions and show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
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
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerList()));
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.deepOrange,
                    )),
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
              height: 500,
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
                        "Customer Management",
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
                          'Submit Customer',
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
      _buildTextField(controller: nameController, label: 'Customer Name'),
      const SizedBox(height: 25),
      _buildTextField(
        controller: cityController,
        label: 'Price',
      ),
      const SizedBox(height: 25),
      _buildTextField(
        controller: phoneController,
        label: 'Discount',
      ),
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
