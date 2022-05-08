import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/foods_provider.dart';
import './food_detail_screen.dart';
import 'package:location/location.dart' as loc;
import 'delivery_confirm_screen.dart';
import './map_screen.dart';
import 'package:geocoding/geocoding.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Color green = const Color.fromARGB(255, 43, 164, 0);
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  var lat = 27.6253;
  var long = 85.5561;
  var delivery_charge = 0.0;
  String address = '';
  late PersistentBottomSheetController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // void didChangeDependencies() {
  //   if (_isinit) {
  //     Provider.of<Cart>(context).cartItems(context).then((_) => setState(() {
  //           isLoading = false;
  //         }));
  //   }
  //   _isinit = false;
  //   super.didChangeDependencies();
  // }

  // @override
  // void setState(fn) {
  //   if (mounted) {
  //     super.setState(fn);
  //   }
  // }

  Future<void> ordercart() async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    final locaData = await loc.Location().getLocation();
    setState(() {
      lat = locaData.latitude!;
      long = locaData.longitude!;
    });
    print(locaData.latitude);
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    setState(() {
      address =
          '${placemarks[0].locality!}, ${placemarks[0].subAdministrativeArea!}, ${placemarks[0].administrativeArea!},${placemarks[0].country!} ';
    });
    print(address);

    // Navigator.of(context).pushNamed(routeName) <--- order screnn
    // await Provider.of<Cart>(context, listen: false).createorder(
    //     context,
    //     (locaData.latitude).toString(),
    //     (locaData.longitude).toString(),
    //     address);
    var dc = await Provider.of<Cart>(context, listen: false)
        .getDeliveryChargeFromcart(context, lat.toString(), long.toString());
    setState(() {
      delivery_charge = dc;
    });

    // await Provider.of<Cart>(context, listen: false).cartItems(context);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context)
        .pushNamed(DeliveryConfirmScreen.routeName, arguments: {
      'delivery_charge': delivery_charge,
      'address': address,
      'lat': lat.toString(),
      'long': long.toString(),
    });

    // Navigator.of(context).pushNamed(routeName) <--- order screnn
  }

  Future<void> deleteRestaurant(String restaurantId) async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    await Provider.of<Cart>(context, listen: false)
        .deleterestaurant(context, restaurantId);
    await Provider.of<Cart>(context, listen: false).cartItems(context);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteCart() async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    await Provider.of<Cart>(context, listen: false).deletecart(context);
    await Provider.of<Cart>(context, listen: false).cartItems(context);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteFood(int foodid) async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    await Provider.of<Cart>(context, listen: false).deletefood(context, foodid);
    await Provider.of<Cart>(context, listen: false).cartItems(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Cart>(context).items;
    return isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(title: const Text('Your Cart')),
            body: list.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.remove_shopping_cart,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Cart is empty.',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        // color: Colors.red[100],
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Scrollbar(
                          isAlwaysShown: true,
                          thickness: 7,
                          radius: const Radius.circular(7),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Card(
                                  color: Colors.grey[300],
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              list[index].restaurantname!,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title:
                                                        const Text('Confirm'),
                                                    content: const Text(
                                                        'Are you sure you want to delete?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child:
                                                            const Text('Okay'),
                                                        onPressed: () {
                                                          deleteRestaurant(list[
                                                                  index]
                                                              .restaurantid!);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ...list[index].foodlist!.map(
                                        (food) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            child: ListTile(
                                              tileColor: Colors.grey[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4,
                                                horizontal: 8,
                                              ),
                                              leading: CircleAvatar(
                                                radius: 30,
                                                child: ClipOval(
                                                  child: Image.network(
                                                    '${Provider.of<Foods>(context).findById(food.foodid!).image}',
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                          'assets/images/noimage.png');
                                                    },
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                              title: Text(food.name!),
                                              subtitle: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    OutlinedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const CircleBorder(),
                                                        side: BorderSide(
                                                            color: green,
                                                            width: 1),
                                                        // <-- Button color
                                                        onPrimary:
                                                            green, // <-- Splash color
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (food.quantity! <=
                                                              1) {
                                                            return;
                                                          } else {
                                                            food.quantity =
                                                                food.quantity! -
                                                                    1;
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        '-',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        '${food.quantity}',
                                                        style: const TextStyle(
                                                          // fontSize: 20,
                                                          color: Colors.black,
                                                          // fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                    OutlinedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const CircleBorder(),
                                                        side: BorderSide(
                                                            color: green,
                                                            width: 1),
                                                        onPrimary: green,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          food.quantity =
                                                              food.quantity! +
                                                                  1;
                                                        });
                                                      },
                                                      child: Text(
                                                        '+',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) =>
                                                            AlertDialog(
                                                          title: const Text(
                                                              'Confirm'),
                                                          content: const Text(
                                                              'Are you sure you want to delete?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text(
                                                                  'Okay'),
                                                              onPressed: () {
                                                                deleteFood(
                                                                    food.id!);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Text(
                                                    'Rs: ${food.quantity! * double.parse(food.price!)}',
                                                  )
                                                ],
                                              ),
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(
                                                      FoodDetailScreen
                                                          .routeName,
                                                      arguments: food.foodid),
                                            ),
                                          );
                                        },
                                      ).toList()
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: list.length,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            'Total: ${Provider.of<Cart>(context).totalAmount}'),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirm'),
                                    content: const Text(
                                        'Are you sure you want to delete the cart?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          deleteCart();
                                        },
                                      )
                                    ],
                                  ),
                                );
                                // Provider.of<Cart>(context, listen: false)
                                //     .deletecart(context)
                                //     .then((_) {
                                //   setState(() {
                                //     isLoading = true;
                                //   });
                                //   Provider.of<Cart>(context, listen: false)
                                //       .cartItems(context)
                                //       .then((_) {
                                //     setState(() {
                                //       setState(() {
                                //         isLoading = false;
                                //       });
                                //     });
                                //   });
                                // });
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.delete),
                                  Text('Clear Cart')
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Choose Delivery Location',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  ordercart();
                                                },
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons
                                                          .location_searching_outlined,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      'Use Current Location',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(MapScreen
                                                            .routeName);
                                                  },
                                                  child: const Text(
                                                      'Choose Location'))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Text(
                                    'Checkout',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          );
  }
}
