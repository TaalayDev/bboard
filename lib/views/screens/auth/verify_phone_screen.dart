import 'package:another_flushbar/flushbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../cubit/auth_cubit.dart';
import '../../../cubit/phone_verification_cubit.dart';
import '../../../res/globals.dart';
import '../../../res/routes.dart';
import '../../../res/theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/countdown_timer.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/phone_field.dart';

class VerifyPhoneScreen extends StatelessWidget {
  const VerifyPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneVerificationCubit(userRepo: getIt.get()),
      child: BlocListener<PhoneVerificationCubit, PhoneVerificationState>(
        listener: (context, state) {
          if (state.codeSent) {
            if (state.status == FormzStatus.submissionSuccess) {
              // context.push(Routes.registration);
              context
                  .read<AuthCubit>()
                  .phoneVerified(state.phone!, state.uid ?? '');
            }
          } else if (state.status == FormzStatus.submissionFailure) {
            FlushbarHelper.createError(
              message: state.error ?? 'Ошибка верификации',
            ).show(context);
          }
        },
        listenWhen: (oldState, newState) => oldState.status != newState.status,
        child: BlocBuilder<PhoneVerificationCubit, PhoneVerificationState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                return true;
              },
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.codeSent ? 'Код из смс' : 'Номер телефона',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!state.codeSent) ...[
                        PhoneField(
                          onChanged: (value) {
                            context
                                .read<PhoneVerificationCubit>()
                                .setPhone(value);
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            CustomCheckbox(
                              initialValue: false,
                              onChanged: (newValue) {
                                context
                                    .read<PhoneVerificationCubit>()
                                    .termsAccepted(newValue);
                              },
                            ),
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
                            context
                                .read<PhoneVerificationCubit>()
                                .setSmsCode(value);
                          },
                        ),
                      const SizedBox(height: 20),
                      AppButton(
                        loading:
                            state.status == FormzStatus.submissionInProgress,
                        text: state.codeSent ? 'Подтвердить' : 'continue'.tr(),
                        onPressed: () {
                          if (!state.codeSent) {
                            if (state.termsAccepted) {
                              context
                                  .read<PhoneVerificationCubit>()
                                  .sendPhoneConfirmation();
                            }
                          } else {
                            context
                                .read<PhoneVerificationCubit>()
                                .verifyPhone();
                          }
                        },
                      ),
                      if (state.codeSent) ...[
                        const SizedBox(height: 30),
                        Center(
                          child: TextButton(
                            onPressed: state.timerRunning
                                ? null
                                : () {
                                    context
                                        .read<PhoneVerificationCubit>()
                                        .sendPhoneConfirmation();
                                  },
                            child: const Text(
                              'Отправить код заново',
                            ),
                          ),
                        ),
                        if (state.timerRunning) ...[
                          CountDownTimer(
                            duration: const Duration(seconds: 60),
                            running: state.timerRunning,
                            whenTimeExpires: () {
                              context
                                  .read<PhoneVerificationCubit>()
                                  .timeExpires();
                            },
                            countDownFormatter: (seconds) =>
                                '0:${seconds < 10 ? '0' : ''}',
                          ),
                        ]
                      ],
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          const SizedBox(width: double.infinity),
                          Text(
                            'Есть профиль?',
                            style: TextStyle(
                              color: context.theme.secondTextColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(Routes.login);
                            },
                            child: Text(
                              'sign in'.tr(),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
