part of 'phone_verification_cubit.dart';

class PhoneVerificationState extends Equatable {
  const PhoneVerificationState({
    this.status = FormzStatus.pure,
    this.error,
    this.phone,
    this.smsCode,
    this.codeSent = false,
    this.timerRunning = false,
    this.termsAccepted = false,
    this.forceResendingToken,
    this.verificationId,
    this.uid,
  });

  final FormzStatus status;
  final String? error;
  final String? phone;
  final String? smsCode;
  final String? uid;
  final bool codeSent;
  final bool termsAccepted;
  final bool timerRunning;
  final int? forceResendingToken;
  final String? verificationId;

  PhoneVerificationState copyWith({
    FormzStatus? status,
    String? error,
    bool? codeSent,
    bool? termsAccepted,
    bool? timerRunning,
    int? forceResendingToken,
    String? verificationId,
    String? phone,
    String? smsCode,
    String? uid,
  }) =>
      PhoneVerificationState(
        status: status ?? this.status,
        error: error,
        codeSent: codeSent ?? this.codeSent,
        termsAccepted: termsAccepted ?? this.termsAccepted,
        timerRunning: timerRunning ?? this.timerRunning,
        forceResendingToken: forceResendingToken ?? this.forceResendingToken,
        verificationId: verificationId ?? this.verificationId,
        phone: phone ?? this.phone,
        smsCode: smsCode ?? this.smsCode,
        uid: uid ?? this.uid,
      );

  @override
  List<Object?> get props => [
        status,
        error,
        phone,
        smsCode,
        codeSent,
        termsAccepted,
        timerRunning,
        forceResendingToken,
        verificationId,
        uid,
      ];
}
