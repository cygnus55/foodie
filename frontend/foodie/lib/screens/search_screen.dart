import 'package:flutter/material.dart';
import 'package:foodie/widgets/foodsearch_row.dart';

import 'package:foodie/widgets/restaurantsearch_row.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);
  static const routeName = '/searchconfirm';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
        appBar: AppBar(title: Text('Search for ${arg['value']}')),
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
        ));
  }
}
