import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/user.dart';
part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit(int userId, {User? user})
      : super(UserDetailsState(
          userId: userId,
          user: user,
        ));
}
