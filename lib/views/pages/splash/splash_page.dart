import 'dart:async';

import 'package:bboard/helpers/sizer_utils.dart';
import 'package:bboard/tools/locale_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../../tools/app_router.dart';
import '../../../resources/constants.dart';
import '../../widgets/app_image.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  _startTimer() async {
    await Jiffy.locale('ru');
    Timer(const Duration(milliseconds: 3000), () async {
      Get.offNamed(AppRouter.main);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00BB29),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: AppImage(
              Assets.icon,
              height: SizerUtils.responsive(128, md: 258, lg: 358, xl: 512),
            ),
          ),
        ],
      ),
    );
  }
}
