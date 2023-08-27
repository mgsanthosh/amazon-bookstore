import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/Cart.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items.keys.toList()[index];
                final quantity = cart.items[item];

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Quantity: $quantity'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Implement your checkout logic
              },
              child: Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}