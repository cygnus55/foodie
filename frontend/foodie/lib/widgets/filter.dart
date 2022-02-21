import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final List<Map<String, dynamic>> _filtername = [
    {
      'name': 'Top Rated',
      '_isactive': false,
    },
    {
      'name': 'Pure Veg',
      '_isactive': false,
    },
    {
      'name': 'Favourite',
      '_isactive': false,
    },
    {
      'name': 'Open Now',
      '_isactive': false,
    },
    {
      'name': 'Offers',
      '_isactive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: _filtername[i]['_isactive']
                    ? BorderSide(color: Theme.of(context).primaryColor)
                    : BorderSide(color: Theme.of(context).dividerColor),
                // primary: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _filtername[i]['name'],
                  style: TextStyle(
                      color: _filtername[i]['_isactive']
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor),
                ),
              ),
              onPressed: () {
                setState(() {
                  _filtername[i]['_isactive'] = !_filtername[i]['_isactive'];
                });
              },
            ),
          );
        },
        itemCount: _filtername.length,
      ),
    );
  }
}
