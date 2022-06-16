import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bboard/res/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';

import '../../../cubit/change_password_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/password_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final changePasswordCubit = ChangePasswordCubit(userRepo: getIt.get());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Изменить пароль',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == FormzStatus.submissionSuccess) {
            context.pop();
            FlushbarHelper.createSuccess(
              message: 'Пароль успешно обновлен!',
            ).show(context);
          } else if (state.status == FormzStatus.submissionFailure) {
            FlushbarHelper.createSuccess(
              message: 'Ошиюка обновления пароля!',
            ).show(context);
          }
        },
        listenWhen: (oldState, newState) => oldState.status != newState.status,
        child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          bloc: ChangePasswordCubit(userRepo: getIt.get()),
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  PasswordField(
                    hintText: 'Новый пароль',
                    onChanged: (value) {
                      changePasswordCubit.setPassword(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    hintText: 'Повторите новый пароль',
                    onChanged: (value) {
                      changePasswordCubit.setRepeatPassword(value);
                    },
                  ),
                  const SizedBox(height: 25),
                  AppButton(
                    text: 'Сохранить',
                    loading: state.isLoading,
                    onPressed: state.status != FormzStatus.invalid
                        ? () {
                            if (state.password.value !=
                                state.repeatPassword.value) {
                              showToast('Пароли не совпадают!');
                            } else {
                              changePasswordCubit.savePassword();
                            }
                          }
                        : null,
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
