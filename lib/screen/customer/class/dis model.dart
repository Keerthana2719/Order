// import 'package:flutter/material.dart';
// import 'package:prj3/screen/customer/class/dis%20service.dart';

// class EditCustomerScreen extends StatefulWidget {
//   final String id;
//   final String initialName;
//   final String initialCity;
//   final String initialPhone;

//   const EditCustomerScreen({
//     Key? key,
//     required this.id,
//     required this.initialName,
//     required this.initialCity,
//     required this.initialPhone,
//   }) : super(key: key);

//   @override
//   _EditCustomerScreenState createState() => _EditCustomerScreenState();
// }

// class _EditCustomerScreenState extends State<EditCustomerScreen> {
//   late TextEditingController nameController;
//   late TextEditingController cityController;
//   late TextEditingController phoneController;

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.initialName);
//     cityController = TextEditingController(text: widget.initialCity);
//     phoneController = TextEditingController(text: widget.initialPhone);
//   }

//   Future<void> updateCustomer() async {
//     bool result = await CusttomerService().updateCustomer(
//       widget.id,
//       nameController.text,
//       cityController.text,
//       phoneController.text,
//     );

//     if (result) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Customer updated successfully!"),
//       ));
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Failed to update customer"),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Customer'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: cityController,
//               decoration: InputDecoration(labelText: "City"),
//             ),
//             TextField(
//               controller: phoneController,
//               decoration: InputDecoration(labelText: "Phone"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: updateCustomer,
//               child: Text("Update Customer"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:prj3/screen/customer/class/dis%20service.dart';

class EditCustomerScreen extends StatefulWidget {
  final String id;
  final String initialName;
  final String initialCity;
  final String initialPhone;

  const EditCustomerScreen({
    super.key,
    required this.id,
    required this.initialName,
    required this.initialCity,
    required this.initialPhone,
  });

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  late TextEditingController nameController;
  late TextEditingController cityController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    cityController = TextEditingController(text: widget.initialCity);
    phoneController = TextEditingController(text: widget.initialPhone);
  }

  Future<void> updateCustomer() async {
    bool result = await CusttomerService().updateCustomer(
      widget.id,
      nameController.text,
      cityController.text,
      phoneController.text,
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Customer updated successfully!"),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to update customer"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateCustomer,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text("Update Customer"),
            ),
          ],
        ),
      ),
    );
  }
}
