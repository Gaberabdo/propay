import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/utils/services/localstorage/hive.dart';
import 'package:gamers_arena/views/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    TextTheme t = Theme.of(context).textTheme;

    // إعادة تذكير بيانات الدخول
    if (HiveHelp.read(Keys.userName) != null &&
        HiveHelp.read(Keys.userPass) != null &&
        HiveHelp.read(Keys.isRemember) != null) {
      if (HiveHelp.read(Keys.isRemember) == true) {
        controller.userNameEditingController.text =
            HiveHelp.read(Keys.userName);
        controller.signInPassEditingController.text =
            HiveHelp.read(Keys.userPass);
        controller.userNameVal = HiveHelp.read(Keys.userName);
        controller.singInPassVal = HiveHelp.read(Keys.userPass);
      }
    }

    if (HiveHelp.read(Keys.isRemember) != null) {
      controller.isRemember = HiveHelp.read(Keys.isRemember);
    }

    return GetBuilder<AuthController>(builder: (_) {
      return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 200.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  VSpace(59.h),
                  Text("تسجيل الدخول", style: t.titleMedium?.copyWith(fontSize: 24.sp)),
                  VSpace(7.h),
                  Text("مرحبًا، قم بتسجيل الدخول للمتابعة!",
                      style: t.bodySmall?.copyWith(
                          fontSize: 14.sp,
                          color: AppThemes.getBlack20Color(),
                          fontWeight: FontWeight.w400)),
                  VSpace(50.h),
                  CustomTextField(
                    hintext: "اسم المستخدم أو البريد الإلكتروني",
                    isPrefixIcon: true,
                    prefixIcon: 'person',
                    controller: controller.userNameEditingController,
                    onChanged: (v) {
                      controller.userNameVal = v;
                      controller.update();
                    },
                  ),
                  VSpace(32.h),
                  CustomTextField(
                    hintext: "كلمة المرور",
                    isPrefixIcon: true,
                    isSuffixIcon: true,
                    obsCureText: controller.isNewPassShow ? true : false,
                    prefixIcon: 'lock',
                    suffixIcon: controller.isNewPassShow ? 'hide' : 'show',
                    controller: controller.signInPassEditingController,
                    onChanged: (v) {
                      controller.singInPassVal = v;
                      controller.update();
                    },
                    onSuffixPressed: () {
                      controller.isNewPassShow = !controller.isNewPassShow;
                      controller.update();
                    },
                  ),
                  VSpace(24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: .82,
                            child: Checkbox(
                                checkColor: AppThemes.getIconBlackColor(),
                                activeColor: AppColors.mainColor,
                                visualDensity: const VisualDensity(
                                  horizontal: -4.0, // تعديل الفارق الأفقي
                                  vertical: -4.0, // تعديل الفارق العمودي
                                ),
                                side: BorderSide(
                                  color: AppThemes.getHintColor(),
                                ),
                                value: controller.isRemember,
                                onChanged: (v) {
                                  controller.isRemember = v!;
                                  HiveHelp.write(Keys.isRemember, v);
                                  controller.update();
                                }),
                          ),
                          HSpace(5.w),
                          Text(
                            "تذكرني",
                            style: t.bodySmall?.copyWith(
                                fontSize: 14.sp,
                                color: Get.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.black30,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.toNamed(RoutesName.forgotPassScreen);
                      //   },
                      //   child: Container(
                      //       padding: EdgeInsets.symmetric(vertical: 8.h),
                      //       child: Text(
                      //         "هل نسيت كلمة المرور؟",
                      //         style: t.displayMedium?.copyWith(fontSize: 16.sp, color: AppColors.mainColor),
                      //       )),
                      // )
                    ],
                  ),
                  VSpace(48.h),
                  AppButton(
                    text: "تسجيل الدخول",
                    isLoading: controller.isLoading ? true : false,
                    bgColor: controller.userNameVal.isEmpty ||
                        controller.singInPassVal.isEmpty
                        ? AppThemes.getInactiveColor()
                        : AppColors.mainColor,
                    onTap: controller.userNameVal.isEmpty ||
                        controller.singInPassVal.isEmpty
                        ? null
                        : controller.isLoading
                        ? null
                        : () async {
                      Helpers.hideKeyboard();
                      await controller.login();

                    },
                  ),
                  VSpace(32.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "ليس لديك حساب؟",
                      style: t.displayMedium
                          ?.copyWith(fontSize: 16.sp, color: AppThemes.getHintColor()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.signUpScreen);
                      },
                      child: Text(
                        "إنشاء حساب",
                        style: t.bodyMedium?.copyWith(fontSize: 16.sp, color: AppColors.mainColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
