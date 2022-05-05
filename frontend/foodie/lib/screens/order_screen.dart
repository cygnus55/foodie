import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import './orderhistorydetail_sreen.dart';

import '../providers/cart_provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/ordersdetails';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Order>(context, listen: false).getorder(context);
  }

  Color getcolor(status) {
    if (status == 'Delivered') {
      return Colors.green[200]!;
    } else if (status == 'Cancelled') {
      return Colors.red[200]!;
    } else {
      return Colors.grey[500]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Order>(context, listen: false).OrderItems;
    return Scaffold(
      appBar: AppBar(title: const Text("Your order history")),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (() {
              Navigator.of(context).pushNamed(OrderDetailScreen.routeName,
                  arguments: list[index].orderid);
            }),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.3,
              padding: const EdgeInsets.all((10)),
              margin: const EdgeInsets.all(10),
              child: Card(
                color: getcolor(list[index].status),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Delivery charge: ${list[index].deliverycharge}'),
                    Text('Status: ${list[index].status}'),
                    Text('Payment method: ${list[index].paymentmethod}')
                  ],
                ),
                elevation: 5,
              ),
            ),
          );
        },
      ),
    );
  }
}
