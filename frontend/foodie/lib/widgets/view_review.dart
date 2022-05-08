import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/review_provider.dart';
import '../providers/reviews_provider.dart';

class ViewReviews extends StatefulWidget {
  ViewReviews(foodid);

  @override
  State<ViewReviews> createState() => _ViewReviewsState();
}

class _ViewReviewsState extends State<ViewReviews> {
  int? foodid;

  @override
  Widget build(BuildContext context) {
    List<Review> reviews = Provider.of<Reviews>(context).items;
    return Container(
        child: reviews.isNotEmpty
            ? Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 2.5,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: const CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.person),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${reviews[index].name}',
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      RatingBar.builder(
                                        ignoreGestures: true,
                                        itemSize: 20,
                                        initialRating:
                                            reviews[index].rating!.toDouble(),
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (_) {
                                          return;
                                        },
                                      ),
                                    ],
                                  ),
                                  Text('${reviews[index].comment}')
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 2.5,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  'No reviews to show',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ));
  }
}
