import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodie/providers/auth_provider.dart';
import 'package:foodie/providers/restaurant_provider.dart';
import 'package:foodie/screens/food_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/restaurants_provider.dart';
import '../providers/foods_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/restaurant';

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  // String url = 'https://www.facebook.com/Dalle.ktm/';
  Future<bool> open(String url) async {
    try {
      await launch(
        url,
        enableJavaScript: true,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _id = ModalRoute.of(context)?.settings.arguments as int;
    final _restaurant = Provider.of<Restaurants>(context).findById(_id);
    final _restaurantmenu =
        Provider.of<Foods>(context).getFoodByRestaurantId(_id);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.33,
                  child: Image(
                    image: NetworkImage(_restaurant.logo!),
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset('assets/images/noimage.png');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    highlightColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 30,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      _restaurant.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 25,
                        initialRating: _restaurant.rating!,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (_) {
                          return;
                        },
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text('${_restaurant.ratingCount}'),
                      const SizedBox(
                        width: 3,
                      ),
                      const Icon(
                        Icons.people,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_pin),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 20,
                            child: FittedBox(
                              child: Text('${_restaurant.address}'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: _restaurant.openStatus == true
                            ? [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.green,
                                ),
                                const Text(
                                  'Open Now',
                                  style: TextStyle(color: Colors.green),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Closes at ${_restaurant.closeTime}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ]
                            : [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.red,
                                ),
                                const Text(
                                  'Closed Now',
                                  style: TextStyle(color: Colors.red),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Opens at ${_restaurant.openTime}',
                                  style: const TextStyle(color: Colors.green),
                                )
                              ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${_restaurant.description}'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              highlightColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.facebook_rounded,
                                  size: 30,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onTap: () {
                                open(_restaurant.facebookLink.toString());
                              },
                            ),
                            const Text('Facebook'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              highlightColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.http,
                                  size: 30,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onTap: () {
                                open(_restaurant.websiteLink.toString());
                              },
                            ),
                            const Text('Website'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              highlightColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.location_pin,
                                  size: 30,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onTap: () {},
                            ),
                            const Text('Location'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              highlightColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: _restaurant.isFavourite!
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _restaurant.isFavourite =
                                      !_restaurant.isFavourite!;
                                });
                                if (Provider.of<Auth>(context, listen: false)
                                    .isAuth) {
                                  Provider.of<Restaurant>(context,
                                          listen: false)
                                      .toggleFav(context, _restaurant.id!);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 3),
                                    content: _restaurant.isFavourite!
                                        ? const Text(
                                            'Restaurant added to favourite.')
                                        : const Text(
                                            'Restaurant removed from favourite.'),
                                  ),
                                );
                              },
                            ),
                            const Text('Favourite'),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 4,
              color: Colors.grey,
            ),
            Flexible(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(70),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: const Center(
                        child: Text(
                          'Menu',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      bottom: const TabBar(
                        tabs: [
                          Tab(
                            icon: Text(
                              'My favourites',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Tab(
                            icon: Text(
                              'Restaurant Menu',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                      children: _restaurantmenu.isNotEmpty
                          ? [
                              const Center(child: Text('my favourite')),
                              ListView.builder(
                                itemCount: _restaurantmenu.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 30,
                                          child: ClipOval(
                                            child: Image.network(
                                              '${_restaurantmenu[i].image}',
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                    'assets/images/noimage.png');
                                              },
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        title: Text(
                                          '${_restaurantmenu[i].name}',
                                        ),
                                        trailing: Text(
                                            '${_restaurantmenu[i].sellingPrice}'),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(
                                                FoodDetailScreen.routeName,
                                                arguments:
                                                    _restaurantmenu[i].id),
                                      ),
                                      const Divider(
                                        thickness: 2.5,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ]
                          : const [
                              Center(child: Text('my favourite')),
                              Center(child: Text('No dish to show')),
                            ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
