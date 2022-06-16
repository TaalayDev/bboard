import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';

import '../../../cubit/auth_cubit.dart';
import '../../../data/constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image.dart';
import '../../widgets/password_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Регистрация',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: AppImage(
                            Assets.icon,
                            width: 120,
                            height: 120,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Полное имя',
                            errorText: state.name?.invalid ?? false ? '' : null,
                          ),
                          onChanged: (value) {
                            context.read<AuthCubit>().nameChanged(value);
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordField(
                          hintText: 'Введите пароль',
                          errorText: state.password.invalid ? '' : null,
                          onChanged: (value) {
                            context.read<AuthCubit>().passwordChanged(value);
                          },
                        ),
                        const SizedBox(height: 20),
                        PasswordField(
                          hintText: 'Повторите пароль',
                          errorText: state.repeatPassword?.invalid ?? false
                              ? ''
                              : null,
                          onChanged: (value) {
                            context
                                .read<AuthCubit>()
                                .repeatPasswordChanged(value);
                          },
                        ),
                        const SizedBox(height: 40),
                        AppButton(
                          text: 'sign up'.tr(),
                          loading:
                              state.status == FormzStatus.submissionInProgress,
                          onPressed: () {
                            if (state.password.value !=
                                state.repeatPassword?.value) {
                              showToast('Пароли не совпадают');
                            } else {
                              context.read<AuthCubit>().register();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
