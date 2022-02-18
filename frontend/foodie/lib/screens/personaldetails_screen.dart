import 'package:flutter/material.dart';

import './tab_screen.dart';

class PersonalDetails extends StatelessWidget {
  const PersonalDetails({Key? key}) : super(key: key);
  static const routeName = "/name";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Personal Details',
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text(
              'Tell us a bit more about yourself',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter Your Name ',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const TabScreen()),
                        ModalRoute.withName(TabScreen.routeName),
                      );
                    },
                    child: const Text('Continue')))
          ],
        ),
      ),
    ));
  }
}
