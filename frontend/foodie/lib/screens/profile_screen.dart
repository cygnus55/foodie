import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import './login_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_screen_provider.dart';
import '../firebase/firebaseapi.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UploadTask? task;
  File? file;
  String imageUrl = '';
  String image = '';
  // final List<Map> _hello = [
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
  bool isloading = true;
  late String username;
  Future<void> _getUserName() async {
    try {
      await Provider.of<Profile>(this.context, listen: false)
          .getAccountDetails();
      print('hello');
      username =
          Provider.of<Profile>(this.context, listen: false).userName as String;
      print('hi');
      print(username);
      setState(() {
        isloading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
    // Provider.of<Profile>(context).getAccountDetails();
    // setState(() {
    //   isloading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(child: CircularProgressIndicator()))
        : SafeArea(
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
                                username,
                                // Provider.of<Profile>(context).userName as String,
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
                        InkWell(
                          onTap: selectFile,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: (imageUrl == '')
                                        ? const NetworkImage(
                                            'https://img.search.brave.com/Rx5A-765-5Ie9Nt6yNnNc7JH1inemybJqdaRcsOXg1k/rs:fit:844:225:1/g:ce/aHR0cHM6Ly90c2Uy/LmV4cGxpY2l0LmJp/bmcubmV0L3RoP2lk/PU9JUC5LS0ZaS2l2/Rms0S2toWVZrRE9F/aDhRSGFFSyZwaWQ9/QXBp')
                                        : NetworkImage(imageUrl))),
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
                                onPressed: () {
                                  // Provider.of<Profile>(context, listen: false).getAccountDetails();

                                  _getUserName();
                                },
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
                        setState(() {
                          isloading = true;
                        });
                        Provider.of<Auth>(context, listen: false).logout();

                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName)
                            .then((_) => {
                                  setState(() {
                                    isloading = false;
                                  })
                                });
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    image = await snapshot.ref.getDownloadURL();

    setState(() {
      imageUrl = image;
    });
  }
}
