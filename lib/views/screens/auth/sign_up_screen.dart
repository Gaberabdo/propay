import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    AuthController controller = Get.find<AuthController>();
    return GetBuilder<AuthController>(builder: (_) {
      return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(200.h),
                  Text("إنشاء حساب",
                      style: t.titleMedium?.copyWith(
                        fontSize: 24.sp,
                      )),
                  VSpace(5.h),
                  Text("مرحبًا، قم بالتسجيل للمتابعة!",
                      style: t.bodySmall?.copyWith(
                          fontSize: 14.sp, color: AppThemes.getBlack20Color())),
                  VSpace(40.h),
                  CustomTextField(
                    hintext: "الاسم الأول",
                    isPrefixIcon: true,
                    prefixIcon: 'edit',
                    controller: controller.signupFirstNameEditingController,
                    onChanged: (v) {
                      controller.signupFirstNameVal = v;
                      controller.update();
                    },
                  ),
                  VSpace(36.h),
                  CustomTextField(
                    hintext: "عنوان البريد الإلكتروني",
                    isPrefixIcon: true,
                    prefixIcon: 'email',
                    controller: controller.emailEditingController,
                    onChanged: (v) {
                      controller.emailVal = v;
                      if (!v.contains('@')) {
                        controller.emailVal = "";
                      }
                      controller.update();
                    },
                  ),
                  VSpace(36.h),
                  CustomTextField(
                    hintext: "العنوان",
                    isPrefixIcon: true,
                    prefixIcon: 'address',
                    controller: controller.addressEditingController,
                    onChanged: (v) {
                      controller.addressVal = v;
                      controller.update();
                    },
                  ),
                  VSpace(36.h),
                  Row(
                    children: [
                      Container(
                        height: Dimensions.textFieldHeight,
                        decoration: BoxDecoration(
                          color: AppThemes.getFillColor(),
                          borderRadius: BorderRadius.circular(32.r),
                          border: Border.all(color: AppColors.mainColor, width: .2),
                        ),
                        child: CountryCodePicker(
                          padding: EdgeInsets.zero,
                          dialogBackgroundColor: AppThemes.getDarkCardColor(),
                          dialogTextStyle: t.bodyMedium?.copyWith(
                            fontSize: 16.sp,
                          ),
                          flagWidth: 29.w,
                          textStyle:
                          t.displayMedium?.copyWith(color: AppColors.mainColor),
                          onChanged: (CountryCode countryCode) {
                            controller.countryCode = countryCode.code!;
                            controller.phoneCode = countryCode.dialCode!;
                          },
                          initialSelection: 'SY',
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                      ),
                      HSpace(16.w),
                      Expanded(
                        child: CustomTextField(
                          hintext: "رقم الهاتف",
                          isPrefixIcon: true,
                          prefixIcon: 'call',
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: controller.phoneNumberEditingController,
                          onChanged: (v) {
                            controller.phoneNumberVal = v;
                            controller.update();
                          },
                        ),
                      ),
                    ],
                  ),
                  VSpace(36.h),
                  CustomTextField(
                    hintext: "كلمة المرور",
                    isPrefixIcon: true,
                    isSuffixIcon: true,
                    obsCureText: controller.isNewPassShow ? true : false,
                    prefixIcon: 'lock',
                    suffixIcon: controller.isNewPassShow ? 'hide' : 'show',
                    controller: controller.signUpPassEditingController,
                    onChanged: (v) {
                      controller.signUpPassVal = v;
                      controller.update();
                    },
                    onSuffixPressed: () {
                      controller.isNewPassShow = !controller.isNewPassShow;
                      controller.update();
                    },
                  ),
                  VSpace(36.h),
                  AppButton(
                    text: "تسجيل",
                    isLoading: controller.isLoading ? true : false,
                    bgColor: controller.signupFirstNameVal.isEmpty ||
                        controller.emailVal.isEmpty ||
                        controller.phoneNumberVal.isEmpty ||
                        controller.signUpPassVal.isEmpty
                        ? AppThemes.getInactiveColor()
                        : AppColors.mainColor,
                    onTap: controller.signupFirstNameVal.isEmpty ||
                        controller.emailVal.isEmpty ||
                        controller.phoneNumberVal.isEmpty ||
                        controller.signUpPassVal.isEmpty
                        ? null
                        : controller.isLoading
                        ? null
                        : () async {
                      Helpers.hideKeyboard();
                      await controller.register();
                    },
                  ),
                  VSpace(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "هل لديك حساب بالفعل؟",
                        style: t.displayMedium?.copyWith(
                            fontSize: 16.sp, color: AppThemes.getHintColor()),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(RoutesName.loginScreen);
                        },
                        child: Text(
                          "تسجيل الدخول",
                          style: t.displayMedium?.copyWith(
                              fontSize: 16.sp, color: AppColors.mainColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
