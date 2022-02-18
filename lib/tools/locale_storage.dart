import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user.dart';

class LocaleStorage {
  static const _defaultBox = 'app_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    _registerAdapters();
    await Hive.openBox(_defaultBox);
  }

  static void _registerAdapters() {
    Hive.registerAdapter(UserAdapter());
  }

  static String? get token => _get('token');
  static set token(String? val) => _put('token', val);

  static bool get isLogin => token != null;

  static User? get currentUser => _get<User>('current_user');
  static set currentUser(User? val) => _put('current_user', val);

  static bool get isDark => _get('is_dark') ?? false;
  static set isDark(bool val) => _put('is_dark', val);

  static bool get skipped => _get('skipped') ?? false;
  static set skipped(bool val) => _put('skipped', val);

  static String get _languageCode => _get('language_code') ?? 'ru';
  static set _languageCode(String val) => _put('language_code', val);
  static String get _localeCode => _get('locale_code') ?? 'RU';
  static set _localeCode(String val) => _put('locale_code', val);

  static Locale get locale => Locale(_languageCode, _localeCode);
  static set locale(Locale val) {
    _languageCode = val.languageCode;
    _localeCode = val.countryCode!;
  }

  static String get identifier => _get('identifier');
  static set identifier(String val) => _put('identifier', val);

  static bool get hasMessage => _get('has_message') ?? false;
  static set hasMessage(bool val) => _put('has_message', val);

  static bool get fcmEnabled => _get('notifications_enabled') ?? true;
  static set fcmEnabled(bool val) => _put('notifications_enabled', val);

  static _put(String name, val) => Hive.box(_defaultBox).put(name, val);
  static T? _get<T>(String name) => Hive.box(_defaultBox).get(name) as T;

  static listenToken(Function() listener) {
    Hive.box(_defaultBox).listenable(keys: ['token']).addListener(listener);
  }

  static removeTokenListener(Function() listener) {
    Hive.box(_defaultBox).listenable(keys: ['token']).removeListener(listener);
  }

  static listenUser(Function() listener) {
    Hive.box(_defaultBox)
        .listenable(keys: ['current_user']).addListener(listener);
  }

  static removeUserListener(Function() listener) {
    Hive.box(_defaultBox)
        .listenable(keys: ['current_user']).removeListener(listener);
  }
}
