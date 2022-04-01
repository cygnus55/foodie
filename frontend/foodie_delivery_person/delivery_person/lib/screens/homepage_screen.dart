import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datamodels/user_location.dart';
import './login_screen.dart';
import '../providers/auth_provider.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);
  static const routeName = '/homepage';

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return isloading
        ? Scaffold(
            body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator())),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Order Page'),
            ),
            body: Align(
              alignment: Alignment.center,
              child: ListView(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isloading = true;
                            });
                            Provider.of<Auth>(context, listen: false)
                                .logout()
                                .then(
                              (_) {
                                Navigator.of(context).pushReplacementNamed(
                                    LoginScreen.routeName);
                              },
                            );
                          },
                          child: const Text('Log out'))),
                  Container(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFD42323)),
                        onPressed: () {},
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              userLocation.latitude.toString() +
                                  " " +
                                  userLocation.longitude.toString(),
                              style: TextStyle(fontSize: 20),
                            ))),
                  ),
                ],
              ),
            ));
  }
}
