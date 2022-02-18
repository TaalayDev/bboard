import 'package:bboard/views/widgets/app_button.dart';
import 'package:bboard/views/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPhonePage extends StatefulWidget {
  const AddPhonePage({Key? key}) : super(key: key);

  @override
  State<AddPhonePage> createState() => _AddPhonePageState();
}

class _AddPhonePageState extends State<AddPhonePage> {
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
                  Navigator.pop(context, _value.removeAllWhitespace);
                } else {
                  Get.snackbar('app_title'.tr, 'Поле телефон не заполнен');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
