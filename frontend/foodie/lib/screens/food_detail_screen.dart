import 'package:flutter/material.dart';
import 'package:foodie/providers/review_provider.dart';
import 'package:foodie/providers/reviews_provider.dart';
import 'package:foodie/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../providers/foods_provider.dart';
import '../providers/food_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

import '../widgets/review_widget.dart';

// ignore: must_be_immutable
class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/food_detail';

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  Color green = const Color.fromARGB(255, 43, 164, 0);
  int _quantity = 1;
  var _isLoading = false;
  late int _id;
  var _undo = false;
  var _disableBack = false;

  void undo(_id) async {
    Future.delayed(const Duration(seconds: 3), () async {
      if (!_undo) {
        setState(() {
          _disableBack = false;
        });
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Cart>(context, listen: false)
            .addToCart(context, _quantity, _id!);
        await Provider.of<Cart>(context, listen: false).cartItems(context);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<Reviews>(context, listen: false).getReviews(context, _id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _id = ModalRoute.of(context)?.settings.arguments as int;
    final _food = Provider.of<Foods>(context).findById(_id);

    // print(_food.id);
    return _isLoading
        ? Scaffold(
            body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator())),
          )
        : WillPopScope(
            onWillPop: () async {
              return !_disableBack;
            },
            child: SafeArea(
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
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
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
                            onTap: _disableBack
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _food.name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                            child: InkWell(
                              highlightColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.favorite,
                                  color: _food.isFavourite!
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _food.isFavourite = !_food.isFavourite!;
                                });
                                if (Provider.of<Auth>(context, listen: false)
                                    .isAuth) {
                                  Provider.of<Food>(context, listen: false)
                                      .toggleFav(context, _food.id!);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 3),
                                    content: _food.isFavourite!
                                        ? const Text('Food added to favourite.')
                                        : const Text(
                                            'Food removed from favourite.'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          ignoreGestures: true,
                          itemSize: 25,
                          initialRating: _food.rating!,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
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
                        Text('${_food.ratingCount}'),
                        const SizedBox(
                          width: 3,
                        ),
                        const Icon(
                          Icons.people,
                          size: 20,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _food.price == _food.sellingPrice
                          ? Text(
                              "Rs ${_food.price}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                            )
                          : Row(
                              children: [
                                Text(
                                  "Rs ${_food.price}",
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Rs ${_food.sellingPrice}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "(${_food.discountPercent}% off)",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                ),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text('${_food.description}'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Quantity',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                        ),
                        Row(
                          children: [
                            OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                side: BorderSide(color: green, width: 2),
                                // <-- Button color
                                onPrimary: green, // <-- Splash color
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_quantity <= 1) {
                                    return;
                                  } else {
                                    _quantity -= 1;
                                  }
                                });
                              },
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Center(
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                side: BorderSide(color: green, width: 2),
                                onPrimary: green,
                              ),
                              onPressed: () {
                                setState(() {
                                  _quantity += 1;
                                });
                              },
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ReviewWidget(_food.id);
                          }),
                      child: Text(
                        'View Reviews',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),

                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 10),
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints.tightFor(height: 50),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (Provider.of<Auth>(context,
                                              listen: false)
                                          .isAuth) {
                                        if (_food.restaurant!.isAvailable! &&
                                            _food.restaurant!.openStatus!) {
                                          setState(() {
                                            _disableBack = true;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  const Duration(seconds: 3),
                                              content: const Text(
                                                  'Food added to cart'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {
                                                  setState(() {
                                                    _undo = true;
                                                    _disableBack = false;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                          undo(_id);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (c) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Food Unavailable'),
                                                content: const Text(
                                                    'Food you are trying to add to cart is currently unavailable.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(c).pop();
                                                    },
                                                    child: const Text('OK'),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const LoginScreen()),
                                          ModalRoute.withName(
                                              LoginScreen.routeName),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.shopping_bag),
                                        ),
                                        Text(
                                          'Add to cart',
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
