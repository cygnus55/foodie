import 'package:flutter/material.dart';
import 'package:foodie/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Cart>(context).cartItems(context);
    return const Center(
      child: Text(
        'This is cart',
      ),
    );
  }
}
