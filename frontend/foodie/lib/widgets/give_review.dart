import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/review_provider.dart';
import '../providers/reviews_provider.dart';

class GiveReview extends StatelessWidget {
  const GiveReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rate = 1.0;
    return Container(
      child: Column(children: [
        Text("Rate"),
        RatingBar.builder(
          ignoreGestures: false,
          itemSize: 30,
          initialRating: 1.0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            rate = rating;
            print(rate);
          },
        ),
        Text("Comment"),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: TextFormField(
            cursorColor: Colors.black,
            style: const TextStyle(height: 2),
            decoration: const InputDecoration(
              hintText: 'Give your comments...',
              contentPadding: EdgeInsets.all(10),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
