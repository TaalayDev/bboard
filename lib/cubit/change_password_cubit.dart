import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../data/repositories/user_repo.dart';
import '../helpers/form_inputs.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({
    required IUserRepo userRepo,
  })  : _userRepo = userRepo,
        super(const ChangePasswordState());

  final IUserRepo _userRepo;

  void setPassword(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password]),
    ));
  }

  void setRepeatPassword(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      repeatPassword: password,
      status: Formz.validate([password, state.password]),
    ));
  }

  void savePassword() async {
    if (state.status != FormzStatus.invalid) return;

    emit(state.copyWith(isLoading: true));
    final response = await _userRepo.changePassword(
      state.password.value,
      state.repeatPassword.value,
    );
    emit(state.copyWith(
      isLoading: false,
      status: response.status
          ? FormzStatus.submissionSuccess
          : FormzStatus.submissionFailure,
    ));
  }
}
