import 'package:flutter/material.dart';
import './login_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  // final List<Map> _hello = [
  //   {
  //     'id' : '0xe5f9',
  //     'family': 'MaterialIcons',
  //     'value': 'Your Rating',
  //   },
  //   {
  //     'id' : '0xe449',
  //     'family': 'MaterialIcons',
  //     'value': 'Your Order',
  //   },
  //   {
  //     'id' : '0xe25b',
  //     'family': 'MaterialIcons',
  //     'value': 'Favourite Orders',
  //   },
  //   {
  //     'id' : '0xf884',
  //     'family': 'MaterialIcons',
  //     'value': 'Your Locations',
  //   },

  // ];

  final List<IconData> _columnIcon = [
    Icons.star,
    Icons.note,
    Icons.favorite,
    Icons.location_on_rounded,
  ];

  final List<String> _columnValues = [
    'Your Ratings',
    'Your Order',
    'Favorite Orders',
    'Your Locations',
  ];

  final List<IconData> _rowIcon = [
    Icons.favorite,
    Icons.notifications,
    Icons.settings,
    Icons.payment,
  ];

  final List<String> _rowValues = [
    'Likes',
    'Notifications',
    'Settings',
    'Payment',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hari Bahadur',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'haribahadur@gmail.com',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'View Activity',
                              style: TextStyle(color: Color(0xFFD42323)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://img.search.brave.com/Rx5A-765-5Ie9Nt6yNnNc7JH1inemybJqdaRcsOXg1k/rs:fit:844:225:1/g:ce/aHR0cHM6Ly90c2Uy/LmV4cGxpY2l0LmJp/bmcubmV0L3RoP2lk/PU9JUC5LS0ZaS2l2/Rms0S2toWVZrRE9F/aDhRSGFFSyZwaWQ9/QXBp'),
                      radius: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite,
                          ),
                        ),
                        const Text('Likes')
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications,
                          ),
                        ),
                        const Text('Notifications')
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.settings,
                          ),
                        ),
                        const Text('Settings')
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.payment,
                          ),
                        ),
                        const Text('Payments'),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _columnIcon.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    leading: Icon(_columnIcon[index],
                        color: Theme.of(context).iconTheme.color),
                    title: Text(_columnValues[index]),
                    onTap: () {},
                  );
                },
              ),
              const Divider(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'About Us',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Send Feedback',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
