import 'package:delivery_person/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class PasswordChangeScreen extends StatelessWidget {
  const PasswordChangeScreen({Key? key}) : super(key: key);
  static const routeName = '/passwordchange';

  @override
  Widget build(BuildContext context) {
    final TextEditingController name = TextEditingController();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          
          'Step 1 of 1',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Colors.white ,fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text(
              'Change your Password',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter Your New Password ',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              controller: name,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      Provider.of<Auth>(context, listen: false)
                          .submitPassword(name.text);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const HomepageScreen()),
                        ModalRoute.withName(HomepageScreen.routeName),
                      );
                    },
                    child: const Text('Continue')))
          ],
        ),
      ),
    ));
  }
}
