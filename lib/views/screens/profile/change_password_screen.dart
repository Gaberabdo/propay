import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/profile_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    ProfileController controller = Get.find<ProfileController>();
    return GetBuilder<ProfileController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkCardColor : AppColors.fillColorColor,
        appBar: CustomAppBar(
          bgColor: Get.isDarkMode
              ? AppColors.darkCardColor
              : AppColors.fillColorColor,
          isReverseIconBgColor: true,
          title:'تغيير كلمة المرور',
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(Dimensions.screenHeight * .05),
              Container(
                height: Dimensions.screenHeight * .85,
                width: double.maxFinite,
                padding: Dimensions.kDefaultPadding,
                decoration: BoxDecoration(
                  color: AppThemes.getDarkBgColor(),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(18.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpace(100.h),
                    Text(
                       'كلمة المرور الجديدة',
                        style: t.displayMedium),
                    VSpace(10.h),
                    GetBuilder<ProfileController>(builder: (_) {
                      return Container(
                        height: 50.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: Dimensions.kBorderRadius,
                          color: AppThemes.getFillColor(),
                          border:
                              Border.all(color: AppColors.mainColor, width: .2),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 20.h,
                              color: Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.textFieldHintColor,
                            ),
                            Expanded(
                              child: CustomTextField(
                                isBorderColor: false,
                                height: 50.h,
                                obsCureText:
                                    controller.isNewPassShow ? true : false,
                                hintext:
                                    "أدخل كلمة المرور الجديدة",
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
                                    "تحديث كلمة المرور",
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
            ],
          ),
        ),
      );
    });
  }
}
