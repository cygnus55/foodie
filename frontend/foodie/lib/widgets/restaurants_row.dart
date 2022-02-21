import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurants_provider.dart';

class RestaurantsRow extends StatelessWidget {
  const RestaurantsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Restaurants>(context).items;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return Column(
            children: [
              SizedBox(
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
                    ),
                  ),
                  elevation: 5,
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
