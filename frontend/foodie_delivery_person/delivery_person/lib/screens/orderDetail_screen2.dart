import 'package:delivery_person/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:delivery_person/providers/order_provider.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import './map_screen.dart';
import './orderDetail_screen3.dart';

class OrderDetailScreen2 extends StatefulWidget {
  const OrderDetailScreen2({Key? key}) : super(key: key);
  static const routeName = '/order_detail2';

  @override
  State<OrderDetailScreen2> createState() => _OrderDetailScreen2State();
}

class _OrderDetailScreen2State extends State<OrderDetailScreen2> {
  @override
  Widget build(BuildContext context) {
    var accept = false;
    var verified = false;
    String _id = ModalRoute.of(context)?.settings.arguments as String;
    final _order = Provider.of<Order>(context).findById(_id);
    var orderid = _order.orderid;
    print(_order.food);
    verifyorder() {
      Provider.of<Order>(context, listen: false).verifyOrder(orderid!, context);
      Navigator.of(context).pushReplacementNamed(
        OrderDetailScreen3.routeName,
        arguments: orderid,
      );
    }

    cancelorder() {
      Provider.of<Order>(context, listen: false).cancelOrder(orderid!, context);
      Navigator.of(context).pushReplacementNamed(HomepageScreen.routeName);
    }

    return Scaffold(
        appBar: AppBar(title: const Text('OrderDetails')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Text('Name : ${_order.customerName}'),
                    Text('Mobile Number:${_order.mobileNumber}'),
                    Text('Distance from your location:${_order.distance} km')
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Delivery Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  children: [
                    const Icon(Icons.delivery_dining),
                    const SizedBox(
                      width: 10,
                    ),
                    _order.deliverylocation![2]!.length <= 26
                        ? Text("${_order.deliverylocation![2]!}")
                        : Text(
                            "${_order.deliverylocation![2]!.substring(0, 25) + '...'}"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.money),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(_order.deliverycharge!),
                  ],
                ),
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  thickness: 1,
                ),
                Text(_order.paymentmethod!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        verifyorder();
                      },
                      child: const Text('Verify'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        cancelorder();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(MapScreen.routeName, arguments: {
                          'latitude': _order.deliverylocation![0],
                          'longitude': _order.deliverylocation![1]
                        });
                      },
                      child: const Text('View customer location'),
                    ),
                  ],
                ),
                const Text(
                  'Food Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  thickness: 1,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        DataTable(
                          columnSpacing: 8,
                          columns: const [
                            DataColumn(
                                label: Text('Name',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Restaurant Name',
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
                            ..._order.food!.map((food) {
                              return DataRow(cells: [
                                DataCell(Center(
                                    child: Container(
                                        width: 30,
                                        child: Text('${food.name}')))),
                                DataCell(Center(
                                  child: Text('${food.restaurantname}'),
                                )),
                                DataCell(
                                    Center(child: Text('${food.quantity}'))),
                                DataCell(Center(child: Text('${food.price}'))),
                                DataCell(Center(
                                  child: Text('${food.cost}'),
                                )),
                              ]);
                            }).toList()
                          ],
                        ),
                      ],
                    );
                  },
                  itemCount: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total Amount :${_order.totalamount}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
