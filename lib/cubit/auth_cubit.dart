import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oktoast/oktoast.dart';

import '../data/repositories/user_repo.dart';
import '../data/models/register_model.dart';
import '../data/storage.dart';
import '../helpers/form_inputs.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final _userRepo = GetIt.I.get<UserRepo>();

  void loginChanged(String value) {
    final login = Login.dirty(value);
    emit(state.copyWith(
      login: login,
      status: Formz.validate([login, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.login, password]),
    ));
  }

  void repeatPasswordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      repeatPassword: password,
      status: Formz.validate([state.login, password]),
    ));
  }

  void nameChanged(String value) {
    final name = StringForm.dirty(value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([state.login, state.password, name]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([state.login, state.password, email]),
    ));
  }

  void phoneVerified(String phone, String uid) {
    emit(state.copyWith(
      login: Login.dirty(phone),
      uid: uid,
      phoneVerified: true,
    ));
  }

  Future<void> login() async {
    if (!state.status.isValidated) return;
    emit(state.loading());
    final login = state.login.value.replaceAll(' ', '');
    final password = state.password.value;
    final response = await _userRepo.login(login, password);
    if (response.status) {
      LocaleStorage.token = response.result?.apiToken;
      LocaleStorage.currentUser = response.result;

      emit(state.authenticated());
    } else {
      emit(state.loginError(error: response.errorData?.toString()));
    }
  }

  Future<void> register() async {
    if (!state.status.isValidated) return;
    emit(state.loading());
    final response = await _userRepo.register(RegisterModel(
      name: state.name!.value,
      login: state.login.value,
      email: state.email!.value,
      password: state.password.value,
      uid: state.uid,
    ));
    if (response.status) {
      LocaleStorage.token = response.result?.apiToken;
      LocaleStorage.currentUser = response.result;

      emit(state.authenticated());
    } else {
      emit(state.loginError(error: response.errorData?.toString()));
    }
  }

  void googleSignIn() async {
    try {
      // Trigger the Google Authentication flow.
      final account = await GoogleSignIn(
        clientId: '74950354939-6mo9fu96i0p3co1m9ki2i0oeh4qdbcoh'
            '.apps.googleusercontent.com',
      ).signIn();
      if (account != null) {
        /*
        final response = await _userRepo.signInWithGoogle(account);
        LocaleStorage.token = response.result?.token;
        emit(state.authenticated());
        */
      }
    } catch (e) {
      print('google sign in error ${e.toString()}');
    }
  }
}
