import 'package:bboard/controllers/user_controller.dart';
import 'package:bboard/tools/app_router.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../resources/theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/phone_field.dart';
import '../../widgets/custom_checkbox.dart';

class VerifyPhonePage extends StatelessWidget {
  const VerifyPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder<UserController>(initState: (state) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            state.controller?.clear();
          });
        }, builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.codeSent ? 'Код из смс' : 'Номер телефона',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              if (!controller.codeSent) ...[
                PhoneField(
                  onChanged: (value) {
                    controller.phone = value;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const CustomCheckbox(checked: true),
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
              ] else
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  onChanged: (value) {
                    controller.smsCode = value;
                  },
                ),
              const SizedBox(height: 20),
              AppButton(
                loading: controller.loading,
                text: controller.codeSent ? 'Подтвердить' : 'continue'.tr,
                onPressed: () {
                  if (!controller.codeSent) {
                    controller.sendPhoneConfirmation();
                  } else {
                    controller.verifyPhone(
                      onSuccess: () {
                        Get.offAndToNamed(AppRouter.registration);
                      },
                      onError: (err) {
                        Get.snackbar('verification error', err.toString());
                      },
                    );
                  }
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
