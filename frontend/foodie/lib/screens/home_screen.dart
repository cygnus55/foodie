import 'package:flutter/material.dart';
import 'package:foodie/widgets/foods_row.dart';
import 'package:foodie/widgets/restaurants_row.dart';
import 'package:foodie/widgets/discountfood.dart';
import 'package:foodie/widgets/Vegeterianfood.dart';
import 'package:foodie/widgets/toprated.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import './search_screen.dart';
import '../providers/search_providers.dart';

import '../widgets/filter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  // Future<void> searchFood(value)async{
  //   await Provider.of<Foods>(context,listen: false).searchfoods(context, value)

  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: TextFormField(
                  onFieldSubmitted: (value) async {
                    await Provider.of<Search>(context, listen: false)
                        .searchfoods(context, value);
                    Navigator.of(context).pushNamed(SearchScreen.routeName,
                        arguments: {'value': value});
                  },
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
              ),
              const SizedBox(
                height: 10,
              ),

              Flexible(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(
                        'Foods for you',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    const FoodsRow(),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(
                        'Restaurants for you',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    const RestaurantsRow(),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(
                        'Offer Food',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    const DiscountFood(),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(
                        'Vegeterian Food',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    const VegeterianFood(),
                    // Container(
                    //   margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    //   child: Text(
                    //     'Top Rated Food',
                    //     style: Theme.of(context).textTheme.headline5?.copyWith(
                    //         fontWeight: FontWeight.w500, color: Colors.black),
                    //   ),
                    // ),
                    // const TopRatedFood(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
