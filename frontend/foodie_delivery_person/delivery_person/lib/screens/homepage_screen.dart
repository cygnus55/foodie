import 'package:delivery_person/providers/order_provider.dart';
import 'package:delivery_person/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datamodels/user_location.dart';
import './login_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);
  static const routeName = '/homepage';

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    Provider.of<Order>(context, listen: false).getorder();
  }

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Order>(context, listen: false).OrderItems;
    var userLocation = Provider.of<UserLocation>(context);
    return isloading
        ? Scaffold(
            body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator())),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Order Page'),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isloading = true;
                      });
                      Provider.of<Auth>(context, listen: false).logout().then(
                        (_) {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName);
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                    ))
              ],
            ),
            body:
                // list.isEmpty
                //     ? Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           const Text(
                //             'Nothing to show',
                //             style: TextStyle(fontSize: 40),
                //           ),
                //           // Container(
                //           //   padding: const EdgeInsets.all(15),
                //           //   width: double.infinity,
                //           //   child: ElevatedButton(
                //           //     onPressed: () {},
                //           //     child: const Text('Log out'),
                //           //   ),
                //           // ),
                //           ElevatedButton(
                //             style: ElevatedButton.styleFrom(
                //                 primary: const Color(0xFFD42323)),
                //             onPressed: () {},
                //             child: Padding(
                //               padding: const EdgeInsets.all(15),
                //               child: Text(
                //                 userLocation.latitude.toString() +
                //                     " " +
                //                     userLocation.longitude.toString(),
                //                 style: const TextStyle(fontSize: 20),
                //               ),
                //             ),
                //           ),
                //         ],
                //       )
                // :
                Column(
              children: [
                Flexible(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 100,
                            child: Card(
                              elevation: 5,
                              color: Colors.grey[300],
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Delivery Charge: '
                                      '${list[index].deliverycharge}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Location :'
                                      '${list[index].deliverylocation![2]}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                // Container(
                //   padding: const EdgeInsets.all(15),
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       setState(() {
                //         isloading = true;
                //       });
                //       Provider.of<Auth>(context, listen: false)
                //           .logout()
                //           .then(
                //         (_) {
                //           Navigator.of(context).pushReplacementNamed(
                //               LoginScreen.routeName);
                //         },
                //       );
                //     },
                //     child: const Text('Log out'),
                //   ),
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFD42323)),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      userLocation.latitude.toString() +
                          " " +
                          userLocation.longitude.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
