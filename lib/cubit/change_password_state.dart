part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = FormzStatus.pure,
    this.password = const Password.pure(),
    this.repeatPassword = const Password.pure(),
    this.isLoading = false,
  });

  final FormzStatus status;
  final Password password;
  final Password repeatPassword;
  final bool isLoading;

  ChangePasswordState copyWith({
    FormzStatus? status,
    Password? password,
    Password? repeatPassword,
    bool? isLoading,
  }) =>
      ChangePasswordState(
        status: status ?? this.status,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object> get props => [status, password, repeatPassword, isLoading];
}
