import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isEnabled = false;
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Otp Vertifcation'),
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
              '+977 9808074162',
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
                      hintText: 'Enter Otp', border: OutlineInputBorder()),
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
                    onPressed: isEnabled ? () {} : null,
                    child: const Text('Proceed')))
          ]),
        ),
      ),
    );
  }
}
