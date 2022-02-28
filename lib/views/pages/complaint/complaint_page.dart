import 'package:bboard/views/pages/complaint/complaint_page_controller.dart';
import 'package:bboard/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../widgets/app_button.dart';

class ComplaintPage extends StatelessWidget {
  const ComplaintPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBackPressed: () {
          Get.back();
        },
        title: 'Пожаловаться на объявление',
      ),
      body: GetBuilder<ComplaintPageController>(
        init: ComplaintPageController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ...controller.types
                    .map((e) => ListTile(
                          onTap: () {
                            controller.changeSelectType(e);
                          },
                          leading: Checkbox(
                            value: controller.selectedType?.id == e.id,
                            onChanged: (val) {
                              controller.changeSelectType(e);
                            },
                          ),
                          title: Text(e.name),
                        ))
                    .toList(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'what did you dislike about this ad?'.tr,
                        ),
                        onChanged: (value) {
                          controller.changeComlaintText(value);
                        },
                      ),
                      const SizedBox(height: 30),
                      AppButton(
                        text: 'send'.tr,
                        loading: controller.isSending,
                        onPressed: () async {
                          if (controller.complaintText.isEmpty) {
                            showToast('Введите текст');
                          } else if (controller.selectedType == null) {
                            showToast('Выберите тип жалобы');
                          } else {
                            final result = await Get.defaultDialog(
                              title:
                                  'Вы действительно хотите отправить жалобу на это объявление?',
                              titleStyle: const TextStyle(fontSize: 16),
                              titlePadding: const EdgeInsets.only(
                                  top: 10, left: 15, right: 15),
                              content: const SizedBox(),
                              confirm: TextButton(
                                onPressed: () async {
                                  Get.back(result: true);
                                },
                                child: Text('yes'.tr),
                              ),
                              cancel: TextButton(
                                onPressed: () {
                                  Get.back(result: false);
                                },
                                child: Text(
                                  'no'.tr,
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            );
                            if (result) {
                              controller.sendComplaint().then((value) {
                                showToast('Ваша жалобы принята!');
                                Get.back();
                              }).onError((error, stackTrace) {
                                showToast('Ошибка при отправке');
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
