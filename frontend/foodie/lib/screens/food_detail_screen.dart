import 'package:flutter/material.dart';
import 'package:foodie/providers/foods_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: must_be_immutable
class FoodDetailScreen extends StatefulWidget {
  FoodDetailScreen({Key? key}) : super(key: key);
  static const routeName = 'food_detail';
  var quantity = 1;
  var isfavourite = false;

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final _id = ModalRoute.of(context)?.settings.arguments as int;
    final _food = Provider.of<Foods>(context).findById(_id);
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
                    image: NetworkImage(_food.image!),
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: InkWell(
                          onTap: Navigator.of(context).pop,
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: InkWell(
                          child: Icon(
                            Icons.favorite,
                            color: widget.isfavourite
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).iconTheme.color,
                          ),
                          onTap: () {
                            setState(() {
                              widget.isfavourite = !widget.isfavourite;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _food.name!,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: 30,
                  initialRating: _food.rating!,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Theme.of(context).primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                Text('(${_food.ratingCount} ratings)')
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _food.price == _food.sellingPrice
                  ? Text(
                      "Rs ${_food.price}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(fontWeight: FontWeight.w700),
                    )
                  : Row(
                      children: [
                        Text(
                          "Rs ${_food.price}",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize:
                                Theme.of(context).textTheme.subtitle1?.fontSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Rs ${_food.sellingPrice}",
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "(${_food.discountPercent}% off)",
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('${_food.description}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Quantity',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (widget.quantity <= 1) {
                              return;
                            } else {
                              widget.quantity -= 1;
                            }
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15))),
                          child: const Center(
                            child: Text(
                              '-',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Container(
                        height: 30,
                        width: 40,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            '${widget.quantity}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.quantity += 1;
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          child: const Center(
                            child: Text(
                              '+',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConstrainedBox(
                          constraints:
                              const BoxConstraints.tightFor(height: 50),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.shopping_bag),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Add to cart',
                                )
                              ],
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints:
                              const BoxConstraints.tightFor(height: 50),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: const [
                                Text(
                                  'Proceed to pay',
                                ),
                                SizedBox(width: 20),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
