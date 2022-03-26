import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/restaurant_detail_screen.dart';
import '../providers/restaurants_provider.dart';

class RestaurantsRow extends StatefulWidget {
  const RestaurantsRow({Key? key}) : super(key: key);

  @override
  State<RestaurantsRow> createState() => _RestaurantsRowState();
}

class _RestaurantsRowState extends State<RestaurantsRow> {
  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Restaurants>(context, listen: false).items;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return Column(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pushNamed(
                    RestaurantDetailScreen.routeName,
                    arguments: list[i].id),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        list[i].logo as String,
                        fit: BoxFit.fill,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset('assets/images/noimage.png');
                        },
                      ),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              Text(list[i].name as String),
            ],
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
