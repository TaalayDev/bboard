part of 'user_details_cubit.dart';

class UserDetailsState extends Equatable {
  const UserDetailsState({
    required this.userId,
    this.user,
    this.isLoading = false,
  });

  final int userId;
  final User? user;
  final bool isLoading;

  UserDetailsState copyWith({
    User? user,
    bool? isLoading,
  }) =>
      UserDetailsState(
        userId: userId,
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [userId, user, isLoading];
}
