import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';

import '../data/models/user.dart';
import '../data/models/user_products_count.dart';
import '../data/repositories/user_repo.dart';
import '../data/storage.dart';
import '../helpers/image_picker.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({bool isLogin = false, required IUserRepo userRepo})
      : _userRepo = userRepo,
        super(UserState(isLogin: isLogin)) {
    on<LoginEvent>(_loginHandler);
    on<FetchUserEvent>(_fetchCurrentUserDetails);
    on<FetchProductsCountEvent>(_fetchProductsCount);
    on<PickImageEvent>(pickImage);
    on<PickImageCameraEvent>(pickCameraImage);
    on<UserChangeEvent>((event, emitter) {
      emitter(state.copyWith(user: event.user));
    });

    if (isLogin) {
      add(FetchUserEvent());
    }
  }

  final IUserRepo _userRepo;

  void _loginHandler(LoginEvent event, Emitter<UserState> emit) {
    emit(state.copyWith(isLogin: true));
    add(FetchUserEvent());
  }

  void _fetchCurrentUserDetails(
    FetchUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isFetchingUser: true));
    final response = await _userRepo.fetchUser();
    emit(state.copyWith(user: response.result, isFetchingUser: false));
  }

  void _fetchProductsCount(
    FetchProductsCountEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isFetchingProductsCount: true));
    final response = await _userRepo.fetchUserProductsCount();
    emit(state.copyWith(
      productsCount: response.result,
      isFetchingProductsCount: false,
    ));
  }

  void pickImage(PickImageEvent event, Emitter<UserState> emitter) async {
    final result = await ImagePicker.pickImages(multiple: false);
    final image = result.isNotEmpty ? result[0] : null;
    emitter(state.copyWith(image: image));
    updateUser();
  }

  void pickCameraImage(
      PickImageCameraEvent event, Emitter<UserState> emitter) async {
    final result = await ImagePicker.pickImageFromCamera();
    if (result != null) {
      emitter(state.copyWith(image: result));
    }
  }

  void updateUser({String? name, Function()? onSuccess}) async {
    final data = <String, dynamic>{
      '_method': 'PATCH',
      if (state.image != null)
        'avatar': MultipartFile.fromBytes(
          await state.image!.readAsBytes(),
          filename: basename(state.image!.path),
        ),
      if (name != null && name.isNotEmpty) 'name': name,
    };
    final response = await _userRepo.updateUser(FormData.fromMap(data));
    if (response.status) {
      LocaleStorage.currentUser = response.result;
      add(UserChangeEvent(response.result));
      onSuccess?.call();
    }
  }
}
