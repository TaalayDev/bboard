import 'package:bboard/views/pages/change_password/change_password_page_controller.dart';
import 'package:bboard/views/widgets/app_button.dart';
import 'package:bboard/views/widgets/custom_app_bar.dart';
import 'package:bboard/views/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Изменить пароль',
        onBackPressed: () {
          Get.back();
        },
      ),
      body: GetBuilder<ChangePasswordPageController>(
        init: ChangePasswordPageController(),
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 20),
                PasswordField(
                  hintText: 'Новый пароль',
                  onChanged: (value) {
                    controller.changeNewPassword(value);
                  },
                ),
                const SizedBox(height: 10),
                PasswordField(
                  hintText: 'Повторите новый пароль',
                  onChanged: (value) {
                    controller.changeRepeatPassword(value);
                  },
                ),
                const SizedBox(height: 25),
                AppButton(
                  text: 'Сохранить',
                  loading: controller.isLoading,
                  onPressed: () {
                    if (controller.newPassword !=
                        controller.newPasswordRepeat) {
                      showToast('Пароли не совпадают!');
                    } else {
                      controller.save().then((value) {
                        showToast('Ваш пароль успешно обновлен!');
                        Get.back();
                      }).onError<Exception>((error, stackTrace) {
                        error.toString();
                        showToast('$error');
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
