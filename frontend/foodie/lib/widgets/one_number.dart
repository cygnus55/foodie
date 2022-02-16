import 'package:flutter/material.dart';

class OneNumber extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;
  const OneNumber(this.controller, this.autofocus, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        autofocus: autofocus,
        keyboardType: TextInputType.number,
        maxLength: 1,
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          counterText: '',
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
