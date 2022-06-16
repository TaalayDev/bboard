import 'dart:io';

import 'package:bboard/res/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event/event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

import 'data/data_provider.dart';
import 'data/events/product_events.dart';
import 'data/repositories/category_repo.dart';
import 'data/repositories/product_repo.dart';
import 'data/repositories/settings_repo.dart';
import 'data/repositories/user_repo.dart';
import 'helpers/network_helpers.dart';
import 'helpers/sizer_utils.dart';
import 'res/routes.dart';
import 'bloc/user_bloc.dart';
import 'data/api_client.dart';
import 'data/storage.dart';
import 'helpers/my_http_overrides.dart';
import 'res/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await LocaleStorage.init();

  await EasyLocalization.ensureInitialized();

  registerDependencies();

  Firebase.initializeApp();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('ru', 'RU')],
    fallbackLocale: const Locale('ru', 'RU'),
    path: 'assets/translations',
    child: const App(),
  ));
}

void registerDependencies() {
  final client = ApiClient(initDio());

  // repositories
  getIt.registerLazySingleton<IUserRepo>(() => UserRepo(client: client));
  getIt.registerLazySingleton<IProductRepo>(() => ProductRepo(client: client));
  getIt.registerLazySingleton<ICategoryRepo>(
    () => CategoryRepo(client: client),
  );
  getIt.registerLazySingleton<ISettingsRepo>(
    () => SettingsRepo(client: client),
  );

  // events
  getIt.registerLazySingleton(() => Event<ProductEvent>());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => DataProvider()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => UserBloc(
                isLogin: LocaleStorage.isLogin,
                userRepo: getIt.get(),
              ),
            ),
          ],
          child: LayoutBuilder(builder: (context, constraints) {
            SizerUtils.init(constraints);
            return MaterialApp.router(
              title: 'app_title'.tr(),
              routeInformationParser: Routes.routeInformationParser,
              routerDelegate: Routes.routerDelegate,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: AppTheme.lightTheme.themeData,
              darkTheme: AppTheme.darkTheme.themeData,
              themeMode: ThemeMode.light,
            );
          }),
        ),
      ),
    );
  }
}
