part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = FormzStatus.pure,
    this.error,
    this.login = const Login.pure(),
    this.password = const Password.pure(),
    this.repeatPassword,
    this.name,
    this.email,
    this.phoneVerified = false,
    this.uid,
  });

  final FormzStatus status;
  final String? error;
  final Login login;
  final Password password;
  final Password? repeatPassword;
  final StringForm? name;
  final Email? email;
  final String? uid;
  final bool phoneVerified;

  AuthState copyWith({
    FormzStatus? status,
    String? error,
    Login? login,
    Password? password,
    Password? repeatPassword,
    StringForm? name,
    Email? email,
    String? uid,
    bool? phoneVerified,
  }) =>
      AuthState(
        status: status ?? this.status,
        error: error,
        login: login ?? this.login,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        name: name ?? this.name,
        email: email ?? this.email,
        phoneVerified: phoneVerified ?? this.phoneVerified,
        uid: uid ?? this.uid,
      );

  AuthState loading() =>
      copyWith(status: FormzStatus.submissionInProgress, error: null);
  AuthState authenticated() => copyWith(status: FormzStatus.submissionSuccess);
  AuthState loginError({String? error}) =>
      copyWith(status: FormzStatus.submissionFailure, error: error);

  @override
  List<Object?> get props => [
        status,
        error,
        login,
        password,
        repeatPassword,
        name,
        email,
        phoneVerified,
        uid,
      ];
}
