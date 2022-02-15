import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hari Bahadur',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.bold)),
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
                          )),
                    )
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
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(
            height: 5,
            color: Colors.black,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        size: 40,
                      )),
                  const Text('Likes')
                ]),
                Column(children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications,
                        size: 40,
                      )),
                  const Text('Notifications')
                ]),
                Column(children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings,
                        size: 40,
                      )),
                  const Text('Settings')
                ]),
                Column(children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.payment,
                        size: 40,
                      )),
                  const Text('Paymnets')
                ]),
              ],
            ),
          ),
          const Divider(
            height: 5,
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.star, color: Colors.black),
              label: Text(
                'Your Ratings',
                style: Theme.of(context).textTheme.subtitle1,
              )),
          const Divider(
            height: 5,
            color: Colors.black,
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.note)),
              const Text('Your Orders'),
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
              const Text('Favourite Orders'),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on_rounded)),
              const Text('Your Locations'),
            ],
          ),
          const Divider(
            height: 5,
            color: Colors.black,
          ),
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
            onPressed: () {},
            child: Text(
              'Logout',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
