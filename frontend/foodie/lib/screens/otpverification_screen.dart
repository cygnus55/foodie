import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/tab_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);
  static const routeName = '/login-otp';

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isEnabled = false;
  final otpController = TextEditingController();

  Future<void> submit(String phoneNumber) async {
    var url = Uri.http('10.0.2.2:8000', 'accounts/login/');
    // // ignore: unused_local_variable
    final http.Response response = await http.post(
      url,
      body: json.encode({
        'mobile': phoneNumber,
        'otp': otpController.text,
      }),
    );
    var status = response.statusCode;
    if (status == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => const TabScreen()),
        ModalRoute.withName(TabScreen.routeName),
      );
    }

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = ModalRoute.of(context)!.settings.arguments;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OTP Vertifcation'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              'We have sent a verification code to ',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '$phoneNumber',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2),
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: 'Enter OTP', border: OutlineInputBorder()),
                  autofocus: true,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  controller: otpController,
                  onChanged: (string) => {
                    if (string.length == 6)
                      {
                        setState(
                          () {
                            isEnabled = true;
                          },
                        )
                      }
                    else
                      {
                        setState(() {
                          isEnabled = false;
                        })
                      }
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive a code ?"),
                TextButton(onPressed: () {}, child: const Text('Resend'))
              ],
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                    onPressed:
                        isEnabled ? () => submit(phoneNumber.toString()) : null,
                    child: const Text('Proceed')))
          ]),
        ),
      ),
    );
  }
}
