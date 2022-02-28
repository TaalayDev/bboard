import 'package:bboard/repositories/user_repo.dart';
import 'package:get/get.dart';

class ChangePasswordPageController extends GetxController {
  String newPassword = '';
  String newPasswordRepeat = '';

  bool isLoading = false;

  final _userRepo = Get.find<UserRepo>();

  void changeNewPassword(String newPassword) {
    this.newPassword = newPassword;
    update();
  }

  void changeRepeatPassword(String newPasswordRepeat) {
    this.newPasswordRepeat = newPasswordRepeat;
    update();
  }

  Future<void> save() async {
    if (newPassword.isEmpty && newPasswordRepeat.isEmpty) return;

    isLoading = true;
    update();

    final response =
        await _userRepo.changePassword(newPassword, newPasswordRepeat);

    isLoading = false;
    update();

    if (!response.status) throw Exception(response.errorData);
  }
}
