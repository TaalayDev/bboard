import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'helpers/my_http_overrides.dart';
import 'helpers/sizer_utils.dart';
import 'resources/app_bindings.dart';
import 'resources/app_translations.dart';
import 'resources/theme.dart';
import 'tools/app_router.dart';
import 'tools/locale_storage.dart';
import 'tools/push_notifications_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await LocaleStorage.init();
  // await Jiffy.locale('ru');
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp();
      PushNotificationsManager().init();
    }

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  } catch (e) {}

  runApp(
    DevicePreview(
      enabled: (kIsWeb || Platform.isWindows) && !kReleaseMode,
      builder: (context) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizerUtils.init(constraints);
      return OKToast(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ru', 'RU'),
          translations: AppTranslations(),
          title: 'Bazar',
          theme: AppTheme.lightTheme.themeData,
          darkTheme: AppTheme.darkTheme.themeData,
          themeMode: ThemeMode.light,
          initialRoute: AppRouter.initialRoute,
          getPages: AppRouter.pages,
          initialBinding: AppBindings(),
        ),
      );
    });
  }
}
