import 'package:flutter/material.dart';
import 'package:foodie/widgets/foods_row.dart';
import 'package:foodie/widgets/restaurants_row.dart';

import '../widgets/filter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 30,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Kathmandu',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.grey),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Explore',
            //   style: Theme.of(context)
            //       .textTheme
            //       .headline4
            //       ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // const Text(
            //   'best dishes for you',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            TextFormField(
              cursorColor: Colors.black,
              style: const TextStyle(height: 2),
              decoration: const InputDecoration(
                hintText: 'Search dishes...',
                contentPadding: EdgeInsets.all(10),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
            ),
            const Filter(),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Foods for you',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  const Divider(),
                  const FoodsRow(),
                  Text(
                    'Restaurants for you',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  const Divider(),
                  const RestaurantsRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
