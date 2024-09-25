import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/bottom_nav_controller.dart';
import 'package:gamers_arena/routes/routes_name.dart';
import 'package:gamers_arena/utils/app_constants.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../notification_service/notification_controller.dart';
import '../../../utils/services/pop_app.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    _connectivity.onConnectivityChanged
        .listen(Get.find<AppController>().updateConnectionStatus);
    Get.put(ProfileController()).getProfile();
    Get.put(PushNotificationController()).getPushNotificationConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (_) {
        return GetBuilder<BottomNavController>(
          builder: (controller) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                body: controller.screens[0],
                // bottomNavigationBar: BottomAppBar(
                //   height: 70.h,
                //   elevation: _.isDarkMode() != null
                //       ? _.isDarkMode() == true
                //           ? 0
                //           : 10
                //       : 0,
                //   color: _.isDarkMode() != null
                //       ? _.isDarkMode() == true
                //           ? AppColors.darkCardColor
                //           : AppColors.whiteColor
                //       : AppColors.darkCardColor,
                //   shadowColor: AppColors.black20,
                //   surfaceTintColor: _.isDarkMode() != null
                //       ? _.isDarkMode() == true
                //           ? AppColors.darkCardColor
                //           : AppColors.whiteColor
                //       : AppColors.darkCardColor,
                //   notchMargin: 8.h,
                //   shape: const CircularNotchedRectangle(),
                //   child: SizedBox(
                //     height: 30.h,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: <Widget>[
                //         IconButton(
                //             padding: EdgeInsets.zero,
                //             icon: Image.asset(
                //               "$rootImageDir/home.png",
                //               height: 24.h,
                //               color: _.isDarkMode() != null
                //                   ? _.isDarkMode() == true
                //                       ? controller.selectedIndex == 0
                //                           ? AppColors.mainColor
                //                           : AppColors.whiteColor
                //                       : controller.selectedIndex == 0
                //                           ? AppColors.mainColor
                //                           : AppColors.blackColor
                //                   : controller.selectedIndex == 0
                //                       ? AppColors.mainColor
                //                       : AppColors.whiteColor,
                //               fit: BoxFit.cover,
                //             ),
                //             onPressed: () {
                //               controller.changeScreen(0);
                //             }),
                //         Padding(
                //           padding: EdgeInsets.only(right: 70.w),
                //           child: IconButton(
                //               padding: EdgeInsets.zero,
                //               icon: Image.asset(
                //                 "$rootImageDir/transaction.png",
                //                 height: 24.h,
                //                 color: _.isDarkMode() != null
                //                     ? _.isDarkMode() == true
                //                         ? controller.selectedIndex == 1
                //                             ? AppColors.mainColor
                //                             : AppColors.whiteColor
                //                         : controller.selectedIndex == 1
                //                             ? AppColors.mainColor
                //                             : AppColors.blackColor
                //                     : controller.selectedIndex == 1
                //                         ? AppColors.mainColor
                //                         : AppColors.whiteColor,
                //               ),
                //               onPressed: () {
                //                 controller.changeScreen(1);
                //               }),
                //         ),
                //         IconButton(
                //             padding: EdgeInsets.zero,
                //             icon: Image.asset(
                //               "$rootImageDir/withdraw.png",
                //               height: 26.h,
                //               color: _.isDarkMode() != null
                //                   ? _.isDarkMode() == true
                //                       ? controller.selectedIndex == 2
                //                           ? AppColors.mainColor
                //                           : AppColors.whiteColor
                //                       : controller.selectedIndex == 2
                //                           ? AppColors.mainColor
                //                           : AppColors.blackColor
                //                   : controller.selectedIndex == 2
                //                       ? AppColors.mainColor
                //                       : AppColors.whiteColor,
                //               fit: BoxFit.cover,
                //             ),
                //             onPressed: () {
                //               controller.changeScreen(2);
                //             }),
                //         IconButton(
                //           icon: Image.asset(
                //             "$rootImageDir/profile.png",
                //             height: 22.h,
                //             color: _.isDarkMode() != null
                //                 ? _.isDarkMode() == true
                //                     ? controller.selectedIndex == 3
                //                         ? AppColors.mainColor
                //                         : AppColors.whiteColor
                //                     : controller.selectedIndex == 3
                //                         ? AppColors.mainColor
                //                         : AppColors.blackColor
                //                 : controller.selectedIndex == 3
                //                     ? AppColors.mainColor
                //                     : AppColors.whiteColor,
                //           ),
                //           onPressed: () {
                //             if (Get.find<ProfileController>()
                //                 .profileList
                //                 .isEmpty) {
                //               Get.find<ProfileController>().getProfile();
                //             }
                //             controller.changeScreen(3);
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // floatingActionButton: controller.hasFocus == true
                //     ? const SizedBox()
                //     : ClipOval(
                //         child: FloatingActionButton(
                //           backgroundColor: AppColors.mainColor,
                //           child: Image.asset(
                //             "$rootImageDir/add_fund.png",
                //             height: 30.h,
                //             color: AppColors.whiteColor,
                //           ),
                //           onPressed: () {
                //             Get.toNamed(RoutesName.addFundScreen);
                //           },
                //         ),
                //       ),
                // floatingActionButtonLocation:
                // FloatingActionButtonLocation.centerDocked,
              ),
            );
          },
        );
      },
    );
  }
}
