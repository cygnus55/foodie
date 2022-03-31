import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return isloading
        ? Scaffold(
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(child: CircularProgressIndicator())),
        )
        :Scaffold(
      appBar: AppBar(
        title: const Text('Order Page'),
      ),
      body:  Center(
        child:ElevatedButton(onPressed:() {
                        setState(() {
                          isloading = true;
                        });
                        Provider.of<Auth>(context, listen: false).logout().then(
                          (_) {
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.routeName);
                          },
                        );
                      }, child:const Text('Log out'))

      ),
    );
  }
}
