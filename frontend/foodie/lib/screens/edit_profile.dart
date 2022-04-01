import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './tab_screen.dart';

import '../providers/auth_provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/edit_profile';

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)?.settings.arguments as Map;

    final TextEditingController name = TextEditingController();
    final TextEditingController phone = TextEditingController();
    name.text = arg['name'];
    phone.text = arg['phone'];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter Your Name ',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                controller: name,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<Auth>(context, listen: false)
                            .editName(name.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save')))
            ],
          ),
        ));
  }
}
