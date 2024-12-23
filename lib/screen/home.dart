// import 'package:flutter/material.dart';
// import 'package:prj3/screen/customer/cust%20page.dart';
// import 'package:prj3/screen/order/desktop.dart';
// import 'package:prj3/responsive/res.dart';
// import 'package:prj3/screen/order/mobile.dart';
// import 'package:prj3/screen/product/prdct%20page.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 6, 24, 124),
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(255, 6, 24, 124),
//           title: const Center(
//               child: Text(
//             'Home',
//             style: TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
//           )),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildNavigationContainer(
//                 context,
//                 'Customer Page',
//                 Colors.orange,
//                 const Customerr(),
//                 delay: 1,
//               ),
//               const SizedBox(height: 16),
//               _buildNavigationContainer(
//                 context,
//                 'Product Page',
//                 Colors.orange,
//                 const Producttt(),
//                 delay: 1,
//               ),
//               const SizedBox(height: 16),
//               _buildNavigationContainer(
//                 context,
//                 'Order Page',
//                 Colors.orange,
//                 const Response(
//                   mobileBody:
//                       Mymobile(), // Replace with your mobile layout widget
//                   desktopBody:
//                       Mydesktop(), // Replace with your desktop layout widget
//                 ),
//                 delay: 400,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavigationContainer(
//     BuildContext context,
//     String title,
//     Color color,
//     Widget page, {
//     required int delay,
//   }) {
//     return TweenAnimationBuilder(
//       tween: Tween<Offset>(begin: const Offset(1, 5), end: const Offset(0, 0)),
//       duration: const Duration(milliseconds: 900),
//       curve: Curves.easeInOut,
//       builder: (context, Offset offset, child) {
//         return Transform.translate(
//           offset: offset * MediaQuery.of(context).size.width,
//           child: child,
//         );
//       },
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => page),
//           );
//         },
//         child: Container(
//           height: 100,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(80),
//           ),
//           child: Center(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<CardData> _cards = [
    CardData(title: "Customer Page", color: Colors.orange),
    CardData(title: "Product Page", color: Colors.blue),
    CardData(title: "Order Page", color: Colors.green),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 24, 124),
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 24, 124),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: _cards.asMap().entries.map((entry) {
            int index = entry.key;
            CardData card = entry.value;

            // Adjust card position and scale for the stack effect
            return Positioned(
              top: 20.0 + index * 10.0, // Overlap effect
              child: Draggable(
                onDragEnd: (details) {
                  if (details.offset.dx > 200) {
                    _handleSwipe("right", index);
                  } else if (details.offset.dx < -200) {
                    _handleSwipe("left", index);
                  }
                },
                feedback: _buildCard(card.title, card.color),
                childWhenDragging: const SizedBox.shrink(),
                child: _buildCard(card.title, card.color),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handleSwipe(String direction, int index) {
    setState(() {
      _cards.removeAt(index);
    });

    if (_cards.isEmpty) {
      // If no more cards, reset stack or navigate
      Navigator.pushReplacementNamed(context, '/nextPage'); // Example route
    } else {
      // Show swipe message or handle logic for the card
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Swiped $direction"),
        ),
      );
    }
  }

  Widget _buildCard(String title, Color color) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CardData {
  final String title;
  final Color color;

  CardData({required this.title, required this.color});
}
