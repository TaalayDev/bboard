import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bboard/res/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/auth_cubit.dart';
import '../../../res/routes.dart';
import '../../../res/theme.dart';
import '../../../data/constants.dart';
import '../../widgets/password_field.dart';
import '../../widgets/phone_field.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneCont = TextEditingController();
  final passwordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(userRepo: getIt.get()),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == FormzStatus.submissionSuccess) {
            context.go(Routes.main);
            FlushbarHelper.createSuccess(
              message: 'Успешно!',
            ).show(context);
          }
          if (state.status == FormzStatus.submissionFailure) {
            FlushbarHelper.createInformation(
              message: 'Проверьте правильность введенных данных',
            ).show(context);
          }
        },
        listenWhen: (oldState, newState) => oldState.status != newState.status,
        child: GestureDetector(
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
        context.push(Routes.resetPassword);
      },
      child: Text(
        'cant sign in'.tr(),
        style: TextStyle(color: context.theme.secondTextColor),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => PhoneField(
        onChanged: (value) {
          context.read<AuthCubit>().loginChanged(value);
        },
        errorText: state.login.invalid ? '' : null,
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return PasswordField(
          hintText: 'password'.tr(),
          errorText: state.password.invalid ? '' : null,
          onChanged: (value) {
            context.read<AuthCubit>().passwordChanged(value);
          },
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => AppButton(
        text: 'sign in'.tr().toUpperCase(),
        loading: state.status == FormzStatus.submissionInProgress,
        onPressed: () async {
          await context.read<AuthCubit>().login();
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
          'dont have a profile?'.tr(),
          style: TextStyle(color: context.theme.secondTextColor),
        ),
        TextButton(
          onPressed: () {
            context.push(Routes.signIn);
          },
          child: Text(
            'sign up'.tr(),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
