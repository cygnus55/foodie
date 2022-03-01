import 'package:flutter/material.dart';
import 'package:foodie/screens/food_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/restaurants_provider.dart';
import '../providers/foods_provider.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/restaurant';

  get children => null;

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
                      Text('(${_restaurant.ratingCount}) ratings'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_pin),
                          Text('${_restaurant.address}'),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.access_time),
                          Text('Open status'),
                          SizedBox(
                            width: 10,
                          ),
                          Text('closes or opens at')
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
                              onTap: () {},
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
                              onTap: () {},
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
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onTap: () {},
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
                    children: [
                      Icon(Icons.directions_car),
                      ListView.builder(
                          itemCount: _restaurantmenu.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: Text(
                                '${_restaurantmenu[i].name}',
                              ),
                              trailing:
                                  Text('${_restaurantmenu[i].sellingPrice}'),
                              onTap: () => Navigator.of(context).pushNamed(
                                  FoodDetailScreen.routeName,
                                  arguments: _restaurantmenu[i].id),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
