import 'package:bboard/tools/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../repositories/user_repo.dart';
import '../tools/locale_storage.dart';
import '../models/user.dart';

class UserController extends GetxController {
  bool loading = false;
  bool codeSent = false;
  bool timerRunning = false;

  String? passwordError;
  String? phoneError;
  String? nameError;

  String? smsCode;

  Asset? image;

  String? _verificationId;

  String? _phone;
  String? _password;
  String? _name;
  String? _uuid;
  int? _forceResendingToken;

  final _firebaseAuth = FirebaseAuth.instance;

  set phone(String? newVal) {
    _phone = newVal;
    phoneError = null;
    update();
  }

  String? get phone => _phone;

  set password(String? newVal) {
    _password = newVal;
    passwordError = null;
    update();
  }

  String? get password => _password;

  set name(String? newVal) {
    _name = newVal;
    nameError = null;
    update();
  }

  String? get name => _name;

  User? get user {
    if (LocaleStorage.currentUser == null) fetchUser();
    return LocaleStorage.currentUser;
  }

  final _userRepo = Get.find<UserRepo>();

  Future<void> pickImage() async {
    final result = await ImagePicker.pickImages([], maxImages: 1);
    image = result.isNotEmpty ? result[0] : null;
    update();
  }

  Future<void> logIn({
    Function? onSuccess,
    Function(dynamic err)? onError,
  }) async {
    if (phone == null || phone!.isEmpty) {
      phoneError = 'Это поле не может быть пустым';
      update();
    } else if (password == null || password!.isEmpty) {
      passwordError = 'Это поле не может быть пустым';
      update();
    } else {
      if (!loading) {
        loading = true;
        update();

        final response =
            await _userRepo.login(phone!.removeAllWhitespace, password!);
        if (response.status && response.data != null) {
          LocaleStorage.token = response.data?.apiToken;
          LocaleStorage.currentUser = response.data;
          onSuccess?.call();
        } else {
          onError?.call(response.errorData);
        }

        loading = false;
        update();
      }
    }
  }

  Future<void> fetchUser() async {
    final response = await _userRepo.fetchUser();
    if (response.status && response.data != null) {
      LocaleStorage.currentUser = response.data;
      update();
    }
  }

  void sendPhoneConfirmation() async {
    print('send phone confirmation $_phone');
    if (_phone != null) {
      loading = true;
      timerRunning = true;
      update();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+' + _phone!.removeAllWhitespace,
        forceResendingToken: _forceResendingToken,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) {},
        verificationFailed: (error) {},
        codeSent: (verificationId, forceResendingToken) {
          codeSent = true;
          _verificationId = verificationId;
          _forceResendingToken = forceResendingToken;
          update();
        },
        codeAutoRetrievalTimeout: (verificationId) {
          timerRunning = false;
          _verificationId = verificationId;
          update();
        },
      );

      loading = false;
      update();
    }
  }

  void verifyPhone({
    Function? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    if (smsCode != null) {
      loading = true;
      update();

      try {
        final credential = PhoneAuthProvider.credential(
            verificationId: _verificationId!, smsCode: smsCode!);

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        _uuid = userCredential.user?.uid;
        _phone = userCredential.user?.phoneNumber;

        onSuccess?.call();
      } on FirebaseAuthException catch (e) {
        onError?.call(e.message);
      }

      loading = false;
      update();
    }
  }

  void clear() {
    loading = false;
    passwordError = null;
    phoneError = null;
    codeSent = false;
    timerRunning = false;
    _phone = null;
    _password = null;
    _name = null;
    _uuid = null;
    _verificationId = null;
    _forceResendingToken = null;
  }
}
