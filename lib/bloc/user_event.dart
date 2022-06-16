part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends UserEvent {}

class LogoutEvent extends UserEvent {}

class FetchUserEvent extends UserEvent {}

class FetchProductsCountEvent extends UserEvent {}

class PickImageEvent extends UserEvent {}

class PickImageCameraEvent extends UserEvent {}

class UserChangeEvent extends UserEvent {
  const UserChangeEvent(this.user);
  final User? user;
}
