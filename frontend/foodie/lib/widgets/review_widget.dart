import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';
import '../providers/reviews_provider.dart';

class ReviewWidget extends StatefulWidget {
  ReviewWidget(foodid);

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  int? foodid;

  @override
  Widget build(BuildContext context) {
    List<Review> reviews = Provider.of<Reviews>(context).items;
    return Container(
      child: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(10),
            height: 100,
            child: Card(
              elevation: 5,
              color: Colors.grey[300],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(reviews[index].name!),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
