import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/auth_cubit.dart';
import '../../../res/globals.dart';
import 'register_screen.dart';
import 'verify_phone_screen.dart';

class PhoneAuthScreen extends StatelessWidget {
  PhoneAuthScreen({Key? key}) : super(key: key);

  final pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(userRepo: getIt.get()),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.phoneVerified) {
            pageViewController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
        listenWhen: (oldState, newState) =>
            oldState.phoneVerified != newState.phoneVerified,
        child: Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            children: const [VerifyPhoneScreen(), RegisterScreen()],
          ),
        ),
      ),
    );
  }
}
