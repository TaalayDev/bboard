import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resources/theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/phone_field.dart';
import '../../widgets/custom_checkbox.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Номер телефона',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            const PhoneField(),
            const SizedBox(height: 20),
            Row(
              children: [
                CustomCheckbox(checked: true),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Я принимаю условия',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.secondTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Пользовательского соглашения',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.primary,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'continue'.tr,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
