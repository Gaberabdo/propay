import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/app_controller.dart';
import 'package:gamers_arena/utils/services/localstorage/hive.dart';
import 'package:gamers_arena/views/widgets/mediaquery_extension.dart';
import 'package:get/get.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/localstorage/keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppController appController = Get.find<AppController>();
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      HiveHelp.read(Keys.token) != null
          ? Get.offAllNamed(RoutesName.bottomNavBar)
          : HiveHelp.read(Keys.isNewUser) != null
              ? Get.offAllNamed(RoutesName.loginScreen)
              : Get.offAllNamed(RoutesName.onbordingScreen);
    });
    appController.getAppConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.mQuery.height,
      height: context.mQuery.height,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/splash_image_bg.jpg"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Image.asset(
            "assets/images/logo.png",
            height: 324.h,
            width: 324.h,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
