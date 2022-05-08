import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import './edit_profile.dart';
import './login_screen.dart';
import './order_screen.dart';
import './favorite_screen.dart';
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
//String imageUrl = '';
  String image = '';
  // final List<Map> _hello = [
  // final List<IconData> _columnIcon = [
  //   Icons.star,
  //   Icons.note,
  //   Icons.favorite,
  // ];

  // final List<String> _columnValues = [
  //   'Your Ratings',
  //   'Your Order',
  //   'Favorites ',
  // ];

  bool isloading = true;

  late Map userinfo;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _getUserName() async {
    try {
      await Provider.of<Profile>(this.context, listen: false)
          .getAccountDetails();
      // print('hello');
      userinfo = Provider.of<Profile>(this.context, listen: false).userprofile!;

      setState(() {
        isloading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    _getUserName();
    super.initState();

    // Provider.of<Profile>(context).getAccountDetails();
    // setState(() {
    //   isloading = false;
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   _getUserName().catchError((error) {
  //     return showDialog(
  //       context: this.context,
  //       builder: (ctx) => AlertDialog(
  //         title: const Text('An error occurred!'),
  //         content: const Text('Something went wrong.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Okay'),
  //             onPressed: () {
  //               Navigator.of(ctx).pop();
  //             },
  //           )
  //         ],
  //       ),
  //     );
  //   });
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(child: CircularProgressIndicator()))
        : SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
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
                                  userinfo['username'] as String,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(userinfo['userMobile'] as String,
                                    // Provider.of<Profile>(context).userName as String,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Text(
                                  userinfo['userEmail'] as String,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.purpleAccent),
                                      shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          EditProfileScreen.routeName,
                                          arguments: {
                                            'name': userinfo['username'],
                                            'phone': userinfo['userMobile']
                                          });
                                    },
                                    child: const Text('Edit Profile'))
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
                                  image: NetworkImage(
                                    userinfo['userProfilePicture'] as String,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      // ListView.builder(
                      //   padding: EdgeInsets.zero,
                      //   shrinkWrap: true,
                      //   itemCount: _columnIcon.length,
                      //   itemBuilder: (ctx, index) {
                      //     return ListTile(
                      //       leading: Icon(_columnIcon[index],
                      //           color: Theme.of(context).iconTheme.color),
                      //       title: Text(_columnValues[index]),
                      //       onTap: () {
                      //         Navigator.of(context)
                      //             .pushNamed(OrderScreen.routeName);
                      //       },
                      //     );
                      //   },
                      // ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(Favorite_screen.routeName);
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.favorite,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Favorites',
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(OrderScreen.routeName);
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.note,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text('Your orders',
                                  style: TextStyle(color: Colors.black))
                            ],
                          )),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isloading = true;
                          });
                          Provider.of<Auth>(context, listen: false)
                              .logout()
                              .then(
                            (_) {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.routeName);
                            },
                          );
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
    Provider.of<Profile>(this.context, listen: false)
        .changeProfilePicture(image);
    setState(() {
      userinfo['userProfilePicture'] = image;
    });

    // setState(() {
    //   imageUrl = image;
    // });
  }
}
