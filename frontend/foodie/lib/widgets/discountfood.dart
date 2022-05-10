import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/food_detail_screen.dart';
import '../providers/foods_provider.dart';

class DiscountFood extends StatefulWidget {
  const DiscountFood({Key? key}) : super(key: key);

  @override
  State<DiscountFood> createState() => _DiscountFoodState();
}

class _DiscountFoodState extends State<DiscountFood> {
  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Foods>(context, listen: false).getDiscountedfood;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(FoodDetailScreen.routeName,
                      arguments: list[i].id);
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        list[i].image as String,
                        fit: BoxFit.cover,
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
