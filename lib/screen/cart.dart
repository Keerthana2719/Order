import 'package:flutter/material.dart';
import 'package:prj3/screen/product/class/model.dart';

class CartPage extends StatelessWidget {
  final List<Product> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('No items in the cart'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("\$${product.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      // Implement remove item functionality if needed
                    },
                  ),
                );
              },
            ),
    );
  }
}
