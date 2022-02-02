import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../controllers/user_controller.dart';
import '../../../resources/constants.dart';
import '../../../tools/app_router.dart';
import '../../../resources/theme.dart';
import '../../widgets/password_field.dart';
import '../../widgets/phone_field.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneCont = TextEditingController();
  final passwordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 80),
                SizedBox(
                  width: double.infinity,
                  child: AppImage(
                    Assets.icon,
                    width: 184,
                    height: 184,
                  ),
                ),
                SizedBox(height: 60),
                _PhoneField(),
                SizedBox(height: 15),
                _PasswordField(),
                SizedBox(height: 20),
                _SubmitButton(),
                SizedBox(height: 45),
                _ResetPasswordButton(),
                SizedBox(height: 30),
                _SignUp(),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordButton extends StatelessWidget {
  const _ResetPasswordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.toNamed(AppRouter.resetPassword);
      },
      child: Text(
        'cant sign in'.tr,
        style: TextStyle(color: Get.theme.secondTextColor),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      initState: (state) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          state.controller?.clear();
        });
      },
      builder: (controller) => PhoneField(
        onChanged: (value) {
          controller.phone = value;
        },
        errorText: controller.phoneError,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (controller) {
      return PasswordField(
        hintText: 'password'.tr,
        errorText: controller.passwordError,
        onChanged: (value) {
          controller.password = value;
        },
      );
    });
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) => AppButton(
        text: 'sign in'.tr.toUpperCase(),
        loading: controller.loading,
        onPressed: () async {
          final result = await controller.logIn(
            onSuccess: () {
              Get.offAllNamed(AppRouter.main);
            },
            onError: (error) {
              Get.snackbar('Ошибка авторизации',
                  'Проверьте правильность введенных данных');
            },
          );
        },
      ),
    );
  }
}

class _SignUp extends StatelessWidget {
  const _SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'dont have a profile?'.tr,
          style: TextStyle(color: Get.theme.secondTextColor),
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRouter.verifyCode);
          },
          child: Text(
            'sign up'.tr,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
