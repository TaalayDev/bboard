import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';

import '../../../data/constants.dart';
import '../../../helpers/sizer_utils.dart';
import '../../../res/routes.dart';
import '../../widgets/app_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  _startTimer() async {
    await Jiffy.locale('ru');
    Timer(const Duration(milliseconds: 3000), () async {
      context.go(Routes.main);
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
