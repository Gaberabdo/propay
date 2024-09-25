import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/bindings/controller_index.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:gamers_arena/views/screens/my_orders/giftCard_order_screen.dart';
import 'package:gamers_arena/views/screens/payment_and_addFund/transaction_screen.dart';
import 'package:gamers_arena/views/screens/profile/profile_setting_screen.dart';
import 'package:gamers_arena/views/widgets/app_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';
import 'home_screen.dart';

class ChargingScreen extends StatefulWidget {
  ChargingScreen({super.key});

  @override
  State<ChargingScreen> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends State<ChargingScreen> {
  bool isCollapsed = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.delete<WithdrawController>();
    Get.delete<AddFundController>();
    Get.put(ProfileController());
    Get.put(DashboardController());

    return GetBuilder<ProfileController>(
      builder: (profileCtrl) {
        return GetBuilder<DashboardController>(
          builder: (dashboardCtrl) {
            return Scaffold(
              key: scaffoldKey,
              appBar: buildAppbar(profileCtrl),
              drawer: buildDrawer(t, storedLanguage, context),
              body: buildChargingAccount(t, dashboardCtrl),
            );
          },
        );
      },
    );
  }

  CustomAppBar buildAppbar(ProfileController profileCtrl) {
    return CustomAppBar(
      toolberHeight: 100.h,
      prefferSized: 100.h,
      isTitleMarginTop: true,
      leading: IconButton(
          padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: Image.asset(
            "$rootImageDir/menu.png",
            height: 26.h,
            width: 26.h,
            color: AppThemes.getIconBlackColor(),
            fit: BoxFit.fitHeight,
          )),
      title: "شحن الحساب",
    );
  }

  buildChargingAccount(TextTheme t, DashboardController controller) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(RoutesName.bottomNavBar);

        return false;
      },
      child: Padding(
        padding: Dimensions.kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VSpace(100.h),
            Text(
              "شحن الحساب",
              style: t.bodyLarge,
            ),
            VSpace(20.h),
            GetBuilder<ProfileController>(builder: (_) {
              return Container(
                height: 50.h,
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 10.w),
                decoration: BoxDecoration(
                  borderRadius: Dimensions.kBorderRadius,
                  color: AppThemes.getFillColor(),
                  border: Border.all(color: AppColors.mainColor, width: .2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        isBorderColor: false,
                        height: 50.h,
                        obsCureText: controller.isNewPassShow ? true : false,
                        hintext: "الرجاء إدخال الرمز للشحن",
                        controller: controller.newPassEditingController,
                        onChanged: (v) {
                          controller.newPassVal.value = v;
                        },
                        bgColor: Colors.transparent,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          controller.newPassObscure();
                        },
                        icon: Image.asset(
                          controller.isNewPassShow
                              ? "$rootImageDir/hide.png"
                              : "$rootImageDir/show.png",
                          height: 20.h,
                          width: 20.w,
                        )),
                  ],
                ),
              );
            }),
            VSpace(24.h),
            Obx(
              () => InkWell(
                onTap: controller.newPassVal.value.isEmpty
                    ? null
                    : controller.isUpdateProfile
                        ? null
                        : () {
                            Helpers.hideKeyboard();
                            controller.validateUpdatePass();
                          },
                borderRadius: Dimensions.kBorderRadius,
                child: Container(
                  width: double.maxFinite,
                  height: Dimensions.buttonHeight,
                  decoration: BoxDecoration(
                    color: controller.newPassVal.value.isEmpty
                        ? AppThemes.getInactiveColor()
                        : AppColors.mainColor,
                    borderRadius: Dimensions.kBorderRadius,
                  ),
                  child: Center(
                    child: controller.isUpdateProfile
                        ? Helpers.appLoader(color: AppColors.whiteColor)
                        : Text(
                            "تأكيد",
                            style: t.bodyLarge
                                ?.copyWith(color: AppColors.whiteColor),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Drawer buildDrawer(TextTheme t, storedLanguage, context) {
  return Drawer(
    child: Column(
      children: [
        GetBuilder<ProfileController>(builder: (_) {
          return SizedBox(
            width: double.maxFinite,
            height: 250.h,
            child: Column(
              children: [
                VSpace(53.h),
                Container(
                  height: 80.h,
                  width: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.imageBgColor,
                    image: _.isLoading || _.userPhoto == ''
                        ? DecorationImage(
                            image: AssetImage(
                              "$rootImageDir/avatar.webp",
                            ),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: CachedNetworkImageProvider(_.userPhoto),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                VSpace(20.h),
                Text(
                  _.isLoading ? "" : _.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyLarge?.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
                VSpace(5.h),
                Text(
                  _.isLoading ? "" : _.userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.displayMedium?.copyWith(
                      fontSize: 16.sp, color: AppThemes.getBlack50Color()),
                )
              ],
            ),
          );
        }),
        ListTile(
          onTap: () {
            Get.offAllNamed(RoutesName.bottomNavBar);
          },
          leading:
              SizedBox(width: 18, height: 18, child: Icon(Icons.home_filled)),
          title: Text(
            'الرئيسية',
            style: t.bodyMedium?.copyWith(fontSize: 16),
          ),
        ),
        ListTile(
          onTap: () {
            Get.offAllNamed(RoutesName.chargingAccount);
          },
          leading: SizedBox(width: 18, height: 18, child: Icon(Icons.payment)),
          title: Text(
            'شحن حسابك',
            style: t.bodyMedium?.copyWith(fontSize: 16),
          ),
        ),
        // ListTile(
        //   onTap: () {
        //     Navigator.pop(context);
        //     Get.toNamed(RoutesName.accreditedListScreen);
        //   },
        //   leading: SizedBox(
        //     width: 18,
        //     height: 18,
        //     child: Icon(Icons.group),
        //   ),
        //   title: Text(
        //
        //     "المعتمدين",
        //     style: t.bodyMedium?.copyWith(fontSize: 16),
        //   ),
        // ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Get.toNamed(RoutesName.supportTicketListScreen);
          },
          leading: SizedBox(
            width: 18,
            height: 18,
            child: Icon(Icons.support_agent)
          ),
          title: Text(

            "الدعم الفني",
            style: t.bodyMedium?.copyWith(fontSize: 16),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Get.toNamed(RoutesName.profileSettingScreen);
          },
          leading: SizedBox(width: 18, height: 18, child: Icon(Icons.settings)),
          title: Text(
            'الاعدادات',
            style: t.bodyMedium?.copyWith(fontSize: 16),
          ),
        ),
        Spacer(),
        ListTile(
          onTap: () {
            buildLogoutDialog(context, t, storedLanguage);
          },
          title: Text(
            'تسجيل الخروج',
            style: t.bodyMedium?.copyWith(fontSize: 16),
          ),
          trailing: Icon(Icons.logout),
        ),
      ],
    ),
  );
}
