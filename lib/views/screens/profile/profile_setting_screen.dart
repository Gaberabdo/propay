import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/verification_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../config/app_colors.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class ProfileSettingScreen extends StatelessWidget {
  final bool? isFromHomePage;
  final bool? isIdentityVerification;
  final bool? isAddressVerification;
  const ProfileSettingScreen(
      {super.key,
      this.isFromHomePage = false,
      this.isIdentityVerification = false,
      this.isAddressVerification = false});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (_) {
      var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
      return GetBuilder<ProfileController>(builder: (profileController) {
        return WillPopScope(
          onWillPop: () async {
            if (isIdentityVerification == true ||
                isAddressVerification == true) {
              Get.offAllNamed(RoutesName.bottomNavBar);
              return false;
            } else {
              Get.back();
              return false;
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(
              bgColor: AppColors.mainColor.withOpacity(.01),
              title: "إعدادات الملف الشخصي",
              toolberHeight: 100.h,
              prefferSized: 100.h,
              leading: isFromHomePage == true
                  ? IconButton(
                      onPressed: () {
                        if (isIdentityVerification == true ||
                            isAddressVerification == true) {
                          Get.offAllNamed(RoutesName.bottomNavBar);
                        } else {
                          Get.back();
                        }
                      },
                      icon: Container(
                        width: 34.h,
                        height: 34.h,
                        padding: EdgeInsets.all(10.5.h),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? AppColors.darkBgColor
                              : AppColors.black5,
                          borderRadius: BorderRadius.circular(12.r),
                          border:
                              Border.all(color: AppColors.mainColor, width: .2),
                        ),
                        child: Image.asset(
                          "$rootImageDir/back.png",
                          height: 32.h,
                          width: 32.h,
                          color: Get.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                          fit: BoxFit.fitHeight,
                        ),
                      ))
                  : const SizedBox(),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // HEADER PORTION
                  GestureDetector(
                    onTap: () {
                      if (Get.find<ProfileController>().userPhoto != '') {
                        Get.to(() => Scaffold(
                            appBar: const CustomAppBar(title: ""),
                            body: PhotoView(
                              imageProvider: NetworkImage(
                                  Get.find<ProfileController>().userPhoto),
                            )));
                      }
                    },
                    child: Container(
                      height: 110.h,
                      width: 110.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: Get.isDarkMode
                                ? AppColors.darkCardColor
                                : AppColors.black30,
                            width: 4.h,
                          ),
                          color: AppColors.imageBgColor,
                          image: Get.find<ProfileController>().isLoading ||
                                  Get.find<ProfileController>().userPhoto == ''
                              ? DecorationImage(
                                  image: AssetImage(
                                    "$rootImageDir/avatar.webp",
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    Get.find<ProfileController>().userPhoto,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                  VSpace(12.h),
                  Text(
                      Get.find<ProfileController>().isLoading
                          ? ""
                          : Get.find<ProfileController>().userName,
                      style: t.bodyLarge),
                  VSpace(5.h),

                  VSpace(35.h),

                  // FOOTER PORTION
                  Container(
                    width: double.maxFinite,
                    padding:
                        EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                    decoration: BoxDecoration(
                      color: AppThemes.getFillColor(),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "سمة",
                          style: t.bodyLarge?.copyWith(
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.w400),
                        ),
                        VSpace(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 38.h,
                                  width: 38.h,
                                  padding: EdgeInsets.all(7.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    color: AppColors.mainColor.withOpacity(.1),
                                  ),
                                  child: Image.asset(
                                    Get.isDarkMode
                                        ? "$rootImageDir/light.png"
                                        : "$rootImageDir/moon.png",
                                    color: AppColors.mainColor,
                                  ),
                                ),
                                HSpace(10.w),
                                Text(
                                  "الوضع المظلم",
                                  style: t.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Transform.scale(
                                scale: .8,
                                child: Switch(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  thumbColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      // Return your custom grey color
                                      return AppThemes.getGreyColor();
                                    },
                                  ),                                  trackColor: MaterialStatePropertyAll(
                                      !Get.isDarkMode
                                          ? Colors.grey.shade300
                                          : AppColors.mainColor),
                                  value: HiveHelp.read(Keys.isDark) ?? true,
                                  onChanged: _.onChanged,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  VSpace(24.h),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24.r)),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 300.h,
                      padding: EdgeInsets.symmetric(
                          vertical: 32.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: AppThemes.getFillColor(),
                        border: Border(
                          top: BorderSide(
                            color: AppColors.mainColor,
                            width: 0.2,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VSpace(16.h),
                          Text(
                            "إعدادات الملف الشخصي",
                            style: t.bodyLarge?.copyWith(
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          VSpace(25.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  Get.find<AppController>().getLanguageList();
                                  Get.toNamed(RoutesName.editProfileScreen);
                                },
                                leading: Container(
                                  height: 36.h,
                                  width: 36.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    color: AppColors.topupColor.withOpacity(.1),
                                  ),
                                  child: Image.asset(
                                      "$rootImageDir/profile_edit.png"),
                                ),
                                title: Text(
                                  "تعديل الملف الشخصي",
                                  style: t.displayMedium,
                                ),
                                trailing: Container(
                                  height: 36.h,
                                  width: 36.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: AppThemes.getDarkCardColor(),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.h,
                                    color: AppThemes.getGreyColor(),
                                  ),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  Get.toNamed(RoutesName.changePasswordScreen);
                                },
                                leading: Container(
                                  height: 36.h,
                                  width: 36.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    color:
                                        AppColors.voucherColor.withOpacity(.1),
                                  ),
                                  child: Image.asset(
                                      "$rootImageDir/lock_main.png"),
                                ),
                                title: Text(
                                  "تغيير كلمة المرور",
                                  style: t.displayMedium,
                                ),
                                trailing: Container(
                                  height: 36.h,
                                  width: 36.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: AppThemes.getDarkCardColor(),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.h,
                                    color: AppThemes.getGreyColor(),
                                  ),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  Get.find<VerificationController>()
                                      .getVerification();
                                  Get.toNamed(
                                      RoutesName.identityVerificationScreen);
                                },
                                leading: Container(
                                  height: 36.h,
                                  width: 36.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    color: AppColors.topupColor.withOpacity(.1),
                                  ),
                                  child: Image.asset(
                                      "$rootImageDir/verification.png"),
                                ),
                                title: Text(
                                  "التحقق من الهوية",
                                  style: t.displayMedium,
                                ),
                                trailing: Container(
                                  height: 36.h,
                                  width: 36.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: AppThemes.getDarkCardColor(),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.h,
                                    color: AppThemes.getGreyColor(),
                                  ),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  buildLogoutDialog(context, t, storedLanguage);
                                },
                                leading: Container(
                                  height: 36.h,
                                  width: 36.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    color:
                                        AppColors.giftcardColor.withOpacity(.1),
                                  ),
                                  child:
                                      Image.asset("$rootImageDir/log_out.png"),
                                ),
                                title: Text(
                                  "تسجيل الخروج",
                                  style: t.displayMedium,
                                ),
                                trailing: const SizedBox.shrink(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}

Future<dynamic> buildLogoutDialog(
    BuildContext context, TextTheme t, storedLanguage) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          storedLanguage['Log Out'] ?? "تسجيل الخروج",
          style: t.bodyLarge?.copyWith(fontSize: 20.sp),
        ),
        content: Text(
          storedLanguage['Do you want to Log Out?'] ?? "هل تريد تسجيل الخروج؟",
          style: t.bodyMedium,
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                storedLanguage['No'] ?? "لا",
                style: t.bodyLarge,
              )),
          MaterialButton(
              onPressed: () async {
                HiveHelp.remove(Keys.token);
                Get.offAllNamed(RoutesName.loginScreen);
              },
              child: Text(
                storedLanguage['Yes'] ?? "نعم",
                style: t.bodyLarge,
              )),
        ],
      );
    },
  );
}
