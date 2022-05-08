import 'package:flutter/material.dart';
import 'package:foodie/widgets/foodfavorite.dart';

import 'package:foodie/widgets/restaurantfavorite.dart';

class Favorite_screen extends StatefulWidget {
  Favorite_screen({Key? key}) : super(key: key);
  static const routeName = '/favorite';

  @override
  State<Favorite_screen> createState() => _Favorite_screenState();
}

class _Favorite_screenState extends State<Favorite_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your favorites")),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Foods',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            const FoodsRow(),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Restaurants',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            const RestaurantsRow(),
          ],
        ),
      ),
    );
  }
}
