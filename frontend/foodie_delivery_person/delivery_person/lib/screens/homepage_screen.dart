import 'package:delivery_person/screens/splash_screen.dart';
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
            body: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 100,
                            child: Card(
                              elevation: 5,
                              color: Colors.grey[400],
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text('ordernumber',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isloading = true;
                      });
                      Provider.of<Auth>(context, listen: false).logout().then(
                        (_) {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName);
                        },
                      );
                    },
                    child: const Text('Log out'),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFD42323)),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      userLocation.latitude.toString() +
                          " " +
                          userLocation.longitude.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
