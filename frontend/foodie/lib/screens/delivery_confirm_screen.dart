import 'package:flutter/material.dart';
import 'package:foodie/screens/order_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import './tab_screen.dart';

class DeliveryConfirmScreen extends StatelessWidget {
  const DeliveryConfirmScreen({Key? key}) : super(key: key);
  static const routeName = '/deliveryconfirm';

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Cart>(context).items;
    var arg = ModalRoute.of(context)?.settings.arguments as Map;
    var delivery_charge = arg['delivery_charge'];
    var address = arg['address'];
    var lat = arg['lat'];
    var long = arg['long'];

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm delivery")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delivery details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Row(
                  children: [
                    const Icon(Icons.delivery_dining),
                    const SizedBox(
                      width: 10,
                    ),
                    address.length <= 26
                        ? Text("$address")
                        : Text("${address.substring(0, 25) + '...'}"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.money),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Rs. $delivery_charge"),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Card(
                color: Colors.grey,
                elevation: 5,
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Order Detail",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text(
                                list[index].restaurantname!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DataTable(
                                columnSpacing: 15,
                                columns: const [
                                  DataColumn(
                                      label: Text('Name',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Quantity',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Unit Price',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Total Price',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                ],
                                rows: [
                                  ...list[index].foodlist!.map((food) {
                                    return DataRow(cells: [
                                      DataCell(Center(
                                          child: Container(
                                              width: 60,
                                              child: Text('${food.name}')))),
                                      DataCell(Center(
                                          child: Text('${food.quantity}'))),
                                      DataCell(
                                          Center(child: Text('${food.price}'))),
                                      DataCell(Center(
                                        child: Text(
                                            '${double.parse(food.price!) * food.quantity!}'),
                                      )),
                                    ]);
                                  }).toList()
                                ],
                              ),
                              // Text(
                              //     "${food.name}-----${food.quantity}*${food.price}=${food.quantity! * double.parse(food.price!)}");
                            ],
                          );
                        },
                        itemCount: list.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Food Price: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("${Provider.of<Cart>(context).totalAmount}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Delivery charge: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("$delivery_charge"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Total price: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        "${Provider.of<Cart>(context, listen: false).totalAmount + delivery_charge}"),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    KhaltiScope.of(context).pay(
                      config: PaymentConfig(
                        amount: ((Provider.of<Cart>(context, listen: false)
                                        .totalAmount +
                                    delivery_charge) *
                                100)
                            .toInt(),
                        productIdentity:
                            '${Provider.of<Cart>(context, listen: false).cartId}',
                        productName: 'Foodie',
                      ),
                      preferences: [
                        PaymentPreference.khalti,
                        PaymentPreference.eBanking,
                        PaymentPreference.connectIPS,
                      ],
                      onSuccess: (su) {
                        const successsnackBar = SnackBar(
                          content: Text('Payment Successful'),
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(successsnackBar);
                        Provider.of<Cart>(context, listen: false)
                            .createorderkhalti(
                                context, lat, long, address, delivery_charge)
                            .then((_) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const TabScreen()),
                            ((route) => route.isFirst),
                          );
                        });
                      },
                      onFailure: (fa) {
                        const failedsnackBar = SnackBar(
                          content: Text('Payment Failed'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(failedsnackBar);
                      },
                      onCancel: () {
                        const cancelsnackBar = SnackBar(
                          content: Text('Payment Cancelled'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(cancelsnackBar);
                      },
                    );
                  },
                  child: const Text('Pay by khalti')),
              ElevatedButton(
                  onPressed: () {
                    const successsnackBar = SnackBar(
                      content: Text('Order Placed Successfully.'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(successsnackBar);
                    Provider.of<Cart>(context, listen: false)
                        .createorderCOD(
                            context, lat, long, address, delivery_charge)
                        .then((_) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const TabScreen()),
                        ((route) => route.isFirst),
                      );
                    });
                  },
                  child: const Text('Cash on delivery'))
            ],
          ),
        ],
      ),
    );
  }
}
