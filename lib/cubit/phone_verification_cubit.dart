import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:oktoast/oktoast.dart';

import '../data/repositories/user_repo.dart';

part 'phone_verification_state.dart';

class PhoneVerificationCubit extends Cubit<PhoneVerificationState> {
  PhoneVerificationCubit({required IUserRepo userRepo})
      : _userRepo = userRepo,
        super(const PhoneVerificationState());

  final IUserRepo _userRepo;

  void setPhone(String? phone) {
    emit(state.copyWith(phone: phone));
  }

  void termsAccepted(bool val) {
    emit(state.copyWith(termsAccepted: val));
  }

  void setSmsCode(String? smsCode) {
    emit(state.copyWith(smsCode: smsCode));
  }

  void timeExpires() {
    emit(state.copyWith(timerRunning: false));
  }

  void sendPhoneConfirmation() async {
    print('phone conf');
    if (!(state.phone == null || state.phone!.isEmpty)) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      final phone = state.phone!.replaceAll(' ', '');
      final response = await _userRepo.checkUserExists(phone);
      if (!response.status) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+' + phone,
          forceResendingToken: state.forceResendingToken,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (credential) {},
          verificationFailed: (error) {
            print('verification failed $error');
          },
          codeSent: (verificationId, forceResendingToken) {
            emit(state.copyWith(
              codeSent: true,
              timerRunning: false,
              verificationId: verificationId,
              forceResendingToken: forceResendingToken,
              status: FormzStatus.submissionSuccess,
            ));
          },
          codeAutoRetrievalTimeout: (verificationId) {
            emit(state.copyWith(
                timerRunning: false, verificationId: verificationId));
          },
        );
      } else {
        showToast('Пользователь с таким номером телефона уже существует!');
        emit(state.copyWith(timerRunning: false, status: FormzStatus.invalid));
      }
    }
  }

  void verifyPhone() async {
    if (state.smsCode != null) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: state.verificationId!,
          smsCode: state.smsCode!,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final uid = userCredential.user?.uid;

        emit(state.copyWith(status: FormzStatus.submissionSuccess, uid: uid));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          error: e.toString(),
        ));
      }
    }
  }
}
