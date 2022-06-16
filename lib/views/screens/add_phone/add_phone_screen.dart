import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_button.dart';
import '../../widgets/phone_field.dart';

class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({Key? key}) : super(key: key);

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить телефон'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'номер телефона',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            PhoneField(
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
            const SizedBox(height: 15),
            AppButton(
              text: 'Продолжить',
              onPressed: () {
                if (_value.isNotEmpty) {
                  Navigator.pop(context, _value.replaceAll(r' ', ''));
                } else {
                  FlushbarHelper.createInformation(
                          message: 'Поле телефон не заполнен')
                      .show(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
