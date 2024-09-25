import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:gamers_arena/views/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/auth_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class CreateNewPassScreen extends StatelessWidget {
  const CreateNewPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AuthController>(builder: (_) {
      return Scaffold(
          appBar: const CustomAppBar(
            title: 'Create New Password',
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
                      Get.isDarkMode? "$rootImageDir/new_pass_header_dark.png":  "$rootImageDir/new_pass_header.png",
                        height: 200.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  VSpace(60.h),
                  Text(
                    'Set the new password for your account so that you can login and access all the features.',
                    textAlign: TextAlign.center,
                    style: t.displayMedium?.copyWith(
                        color: AppThemes.getBlack50Color(), height: 1.75),
                  ),
                  VSpace(48.h),
                  CustomTextField(
                    hintext: " New Password",
                    isPrefixIcon: true,
                    isSuffixIcon: true,
                    obsCureText: controller.isNewPassShow ? true : false,
                    prefixIcon: 'lock',
                    suffixIcon: controller.isNewPassShow ? 'hide' : 'show',
                    controller: controller.forgotPassNewPassEditingController,
                    onChanged: (v) {
                      controller.forgotPassNewPassVal = v;
                      controller.update();
                    },
                    onSuffixPressed: () {
                      controller.isNewPassShow = !controller.isNewPassShow;
                      controller.update();
                    },
                  ),
                  VSpace(40.h),
                  CustomTextField(
                    hintext: "Confirm Password",
                    isPrefixIcon: true,
                    isSuffixIcon: true,
                    obsCureText: controller.isConfirmPassShow ? true : false,
                    prefixIcon: 'lock',
                    suffixIcon: controller.isConfirmPassShow ? 'hide' : 'show',
                    controller:
                        controller.forgotPassConfirmPassEditingController,
                    onChanged: (v) {
                      controller.forgotPassConfirmPassVal = v;
                      controller.update();
                    },
                    onSuffixPressed: () {
                      controller.isConfirmPassShow =
                          !controller.isConfirmPassShow;
                      controller.update();
                    },
                  ),
                  VSpace(60.h),
                  AppButton(
                    text: "Continue",
                    isLoading: controller.isLoading ? true : false,
                    bgColor: controller.forgotPassNewPassVal.isEmpty ||
                            controller.forgotPassConfirmPassVal.isEmpty
                        ? AppThemes.getInactiveColor()
                        : AppColors.mainColor,
                    onTap: controller.forgotPassNewPassVal.isEmpty ||
                            controller.forgotPassConfirmPassVal.isEmpty
                        ? null
                        : controller.isLoading
                            ? null
                            : () async {
                                if (controller
                                        .forgotPassNewPassEditingController
                                        .text !=
                                    controller
                                        .forgotPassConfirmPassEditingController
                                        .text) {
                                  Helpers.showToast(
                                      msg:
                                          "New Password and Confirm Password didn't match!");
                                } else {
                                  Helpers.hideKeyboard();
                                  await controller.updatePass();
                                }
                              },
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
