import 'package:another_flushbar/flushbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';

import '../../../cubit/complaint_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/dialogs.dart';

class ComplaintScreen extends StatelessWidget {
  const ComplaintScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final int productId;

  @override
  Widget build(BuildContext context) {
    final complaintCubit = ComplaintCubit(productId)..fetchComplaintTypes();
    return Scaffold(
      appBar: CustomAppBar(
        onBackPressed: () {
          Navigator.pop(context);
        },
        title: 'Пожаловаться на объявление',
      ),
      body: BlocListener<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
          if (state.status == ComplaintStatus.success) {
            Navigator.pop(context);
            FlushbarHelper.createSuccess(
              message: 'Ваша жалоба принята',
            ).show(context);
          } else {
            FlushbarHelper.createError(
              message: 'Ошибка при отправке!',
            ).show(context);
          }
        },
        listenWhen: (oldState, newState) => oldState.status != newState.status,
        bloc: complaintCubit,
        child: BlocBuilder<ComplaintCubit, ComplaintState>(
          bloc: complaintCubit,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  if (state.isLoading && state.types.isEmpty) ...[
                    const CircularProgressIndicator.adaptive(),
                  ],
                  ...state.types
                      .map((e) => ListTile(
                            onTap: () {
                              complaintCubit.setComplaintType(e);
                            },
                            leading: Checkbox(
                              value: state.selectedType?.id == e.id,
                              onChanged: (val) {
                                complaintCubit.setComplaintType(e);
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
                            hintText:
                                'what did you dislike about this ad?'.tr(),
                          ),
                          onChanged: (value) {
                            complaintCubit.setText(value);
                          },
                        ),
                        const SizedBox(height: 30),
                        AppButton(
                          text: 'send'.tr(),
                          loading: state.isLoading,
                          onPressed: () async {
                            if (state.text == null || state.text!.isEmpty) {
                              showToast('Введите текст');
                            } else if (state.selectedType == null) {
                              showToast('Выберите тип жалобы');
                            } else {
                              final result = await defaultDialog(
                                context: context,
                                title:
                                    'Вы действительно хотите отправить жалобу на это объявление?',
                                titleStyle: const TextStyle(fontSize: 16),
                                titlePadding: const EdgeInsets.only(
                                    top: 10, left: 15, right: 15),
                                content: const SizedBox(),
                                confirm: TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('yes'.tr()),
                                ),
                                cancel: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text(
                                    'no'.tr(),
                                    style: const TextStyle(
                                        color: Colors.redAccent),
                                  ),
                                ),
                              );
                              if (result) {
                                complaintCubit.sendComplaint();
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
      ),
    );
  }
}
