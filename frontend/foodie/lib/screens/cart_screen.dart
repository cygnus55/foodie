import 'package:flutter/material.dart';
import 'package:foodie/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isinit = true;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      Provider.of<Cart>(context).cartItems(context);
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Cart>(context).items;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(list[index].restaurantname!),
                    const Icon(Icons.close)
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const Center(child: Text('ITEM'))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Center(child: const Text('QTY'))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Center(child: const Text('PRICE'))),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              ...list[index].foodlist!.map((food) {
                return Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.close,
                              size: 10,
                            ),
                            Center(child: Text(food.name!)),
                          ],
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Center(child: Text((food.quantity).toString()))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Center(child: Text(food.price!)))
                  ],
                );
              }).toList()
            ],
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
