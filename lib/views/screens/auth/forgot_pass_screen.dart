import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:gamers_arena/views/widgets/custom_appbar.dart';
import 'package:gamers_arena/views/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/auth_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/spacing.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AuthController>(builder: (_) {
      return Scaffold(
          appBar: const CustomAppBar(
            title: 'Forgot Password',
            actions: [],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 70.h),
                    child: Center(
                      child: Image.asset(
                      Get.isDarkMode ? "$rootImageDir/forgot_pass_header_dark.png":  "$rootImageDir/forgot_pass_header.png",
                        height: 200.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  VSpace(59.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.w),
                    child: Text(
                      "Kindly provide your email address for password recovery purposes.",
                      textAlign: TextAlign.center,
                      style: t.displayMedium?.copyWith(
                          color: AppThemes.getBlack50Color(), height: 1.5),
                    ),
                  ),
                  VSpace(60.h),
                  CustomTextField(
                    hintext: "Enter Email Address",
                    isPrefixIcon: true,
                    prefixIcon: 'email',
                    controller: controller.forgotPassEmailEditingController,
                    onChanged: (v) {
                      controller.forgotPassEmailVal = v;
                      if (!v.contains('@')) {
                        controller.forgotPassEmailVal = "";
                      }
                      controller.update();
                    },
                  ),
                  VSpace(48.h),
                  AppButton(
                    text: "Reset Password",
                    isLoading: controller.isLoading ? true : false,
                    bgColor: controller.forgotPassEmailVal.isEmpty
                        ? AppThemes.getInactiveColor()
                        : AppColors.mainColor,
                    onTap: controller.forgotPassEmailVal.isEmpty
                        ? null
                        : controller.isLoading
                            ? null
                            : () async {
                                Helpers.hideKeyboard();
                                await controller.forgotPass();
                              },
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
