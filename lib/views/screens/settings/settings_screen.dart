import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/user_bloc.dart';
import '../../../data/storage.dart';
import '../../../res/routes.dart';
import '../../../res/theme.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'settings'.tr()),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                CustomCard(
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFc4c4c4),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            InkWell(
                              onTap: () => selectPickerSource(context),
                              child: const _Avatar(),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: context.theme.greyWeak,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Feather.edit_2,
                                  size: 11,
                                  color: context.theme.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Личные данные'),
                ),
                CustomCard(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('Имя'),
                            ),
                            Expanded(
                              flex: 4,
                              child: SizedBox(
                                height: 35,
                                child: TextFormField(
                                  initialValue: state.user?.name ?? '',
                                  onFieldSubmitted: (value) {
                                    if (value.isNotEmpty) {
                                      context.read<UserBloc>().updateUser(
                                            name: value,
                                            onSuccess: () {
                                              FlushbarHelper.createSuccess(
                                                message: 'Успешно сохранено!',
                                              ).show(context);
                                            },
                                          );
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                          height: 35,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text('Телефон'),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(state.user?.phone ?? ''),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Сменить пароль от личного кабинета',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.theme.primary,
                          ),
                        ),
                        onTap: () {
                          context.push(Routes.changePassword);
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        title: Text(
                          'Выйти',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.theme.primary,
                          ),
                        ),
                        onTap: () {
                          context.read<UserBloc>().add(LogoutEvent());
                          LocaleStorage.token = null;
                          context.go(Routes.main);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void selectPickerSource(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      userBloc.add(PickImageEvent());
      return;
    }

    Scaffold.of(context).showBottomSheet(
      (context) => Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Feather.image),
              title: const Text('Галерея'),
              onTap: () async {
                Navigator.pop(context);
                userBloc.add(PickImageEvent());
              },
            ),
            ListTile(
              leading: const Icon(Feather.camera),
              title: const Text('Камера'),
              onTap: () async {
                Navigator.pop(context);
                userBloc.add(PickImageCameraEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state.image != null) {
          if (kIsWeb) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: state.image != null
                  ? Image.network(
                      state.image!.path,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(),
            );
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: state.image != null
                ? Image.file(
                    state.image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(),
          );
        }

        if (state.user?.avatar != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: AppNetworkImage(
              imageUrl: state.user!.avatar!,
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
          );
        }

        return const Icon(
          Feather.user,
          color: Colors.white,
          size: 80,
        );
      },
    );
  }
}
