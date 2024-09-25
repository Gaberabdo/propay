import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamers_arena/controllers/verification_controller.dart';
import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class TwoFaVerificationScreen extends StatelessWidget {
  const TwoFaVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<VerificationController>(
        builder: (verificationController) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkCardColor : AppColors.fillColorColor,
        appBar: CustomAppBar(
          bgColor: Get.isDarkMode
              ? AppColors.darkCardColor
              : AppColors.fillColorColor,
          title: storedLanguage['Two Step Security'] ?? "Two Step Security",
        ),
        body: Column(
          children: [
            VSpace(20.h),
            Expanded(
              child: Container(
                padding: Dimensions.kDefaultPadding,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppThemes.getDarkCardColor(),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.r)),
                ),
                child: verificationController.isLoading
                    ? Helpers.appLoader()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            VSpace(24.h),
                            Container(
                              height: 184.h,
                              width: 184.h,
                              padding: EdgeInsets.all(16.h),
                              decoration: BoxDecoration(
                                color: AppThemes.getFillColor(),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "$rootImageDir/two_fa_image.png",
                              ),
                            ),
                            VSpace(24.h),
                            Text(
                              storedLanguage['Two Factor Authenticator'] ??
                                  "Two Factor Authenticator",
                              style: context.t.bodyLarge,
                            ),
                            VSpace(16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 43.h,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 16.h),
                                    decoration: BoxDecoration(
                                      border: const Border(
                                        bottom: BorderSide(
                                            color: AppColors.black10),
                                        top: BorderSide(
                                            color: AppColors.black10),
                                        left: BorderSide(
                                            color: AppColors.black10),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32.r),
                                        bottomLeft: Radius.circular(32.r),
                                      ),
                                    ),
                                    child: Text(
                                      "${verificationController.secretKey}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodySmall?.copyWith(
                                          color: Get.isDarkMode
                                              ? AppColors.whiteColor
                                              : AppColors.black50),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // ScaffoldMessenger.of(context)
                                    //     .removeCurrentSnackBar();

                                    Clipboard.setData(new ClipboardData(
                                        text:
                                            "${verificationController.secretKey}"));
                                    // Helpers.showSnackBar(
                                    //     msg: "Copied Successfully",
                                    //     title: 'Success',
                                    //     bgColor: AppColors.greenColor);
                                    Helpers.showToast(
                                        msg: "Copied Successfully",
                                        gravity: ToastGravity.CENTER,
                                        bgColor: AppColors.whiteColor,
                                        textColor: AppColors.blackColor);
                                  },
                                  child: Container(
                                    height: 44.h,
                                    width: 41.w,
                                    padding: EdgeInsets.all(12.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(32.r),
                                        bottomRight: Radius.circular(32.r),
                                      ),
                                    ),
                                    child:
                                        Image.asset("$rootImageDir/copy.png"),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(32.h),
                            Container(
                              height: 270.h,
                              width: 220.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.h),
                                    height: 200.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "$rootImageDir/frame.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Image.network(
                                        '${verificationController.qrCodeUrl}'),
                                  ),
                                  const Spacer(),
                                  Stack(
                                    alignment: Alignment.topCenter,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Transform.rotate(
                                        angle: .85,
                                        child: Container(
                                          height: 20.h,
                                          width: 35.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 30.h,
                                        width: 220.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(8.r)),
                                        ),
                                        child: Text(
                                          storedLanguage['Scane Here'] ??
                                              "Scane Here",
                                          style: context.t.displayMedium
                                              ?.copyWith(
                                                  color: AppColors.whiteColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VSpace(32.h),
                            SizedBox(
                              width: double.maxFinite,
                              height: Dimensions.buttonHeight,
                              child: MaterialButton(
                                color: AppColors.mainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.r),
                                ),
                                onPressed: () {
                                  Get.defaultDialog(
                                      barrierDismissible: false,
                                      titlePadding: EdgeInsets.only(top: 10.h),
                                      titleStyle: context.t.bodyLarge,
                                      title:
                                          storedLanguage['2 Step Security'] ??
                                              '2 Step Security',
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              storedLanguage[
                                                      'Verify your OTP'] ??
                                                  'Verify your OTP',
                                              style: context.t.bodySmall,
                                            ),
                                            SizedBox(height: 20.h),
                                            CustomTextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                contentPadding:
                                                    EdgeInsets.only(left: 10.w),
                                                bgColor:
                                                    AppThemes.getDarkBgColor(),
                                                hintext: storedLanguage[
                                                        'Enter Code'] ??
                                                    "Enter Code",
                                                controller:
                                                    verificationController
                                                        .TwoFAEditingController),
                                          ],
                                        ),
                                      ),
                                      cancel: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors
                                              .redColor, // Customize the button color
                                        ),
                                        onPressed: () {
                                          Get.back(); // Close the dialog
                                        },
                                        child: Text(
                                          storedLanguage['Cancel'] ?? 'Cancel',
                                          style: context.t.bodySmall?.copyWith(
                                              color: AppColors.whiteColor),
                                        ),
                                      ),
                                      confirm:
                                          GetBuilder<VerificationController>(
                                              builder:
                                                  (verificationController) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors
                                                  .mainColor // Customize the button color
                                              ),
                                          onPressed:
                                              verificationController.isVerifying
                                                  ? null
                                                  : () async {
                                                      if (verificationController
                                                          .TwoFAEditingController
                                                          .text
                                                          .isNotEmpty) {
                                                        if (verificationController
                                                                .isTwoFactorEnabled ==
                                                            false) {
                                                          await verificationController
                                                              .enableTwoFa(
                                                            context: context,
                                                            fields: {
                                                              "code":
                                                                  "${verificationController.TwoFAEditingController.text}",
                                                              "key":
                                                                  verificationController
                                                                      .secretKey
                                                                      .toString(),
                                                            },
                                                          );
                                                        } else {
                                                          await verificationController
                                                              .disableTwoFa(
                                                            context: context,
                                                            fields: {
                                                              "code": verificationController
                                                                  .TwoFAEditingController
                                                                  .text,
                                                            },
                                                          );
                                                        }
                                                      }
                                                    },
                                          child: Text(
                                            verificationController.isVerifying
                                                ? storedLanguage[
                                                        'Verifying...'] ??
                                                    'Verifying...'
                                                : storedLanguage['Verify'] ??
                                                    'Verify',
                                            style: context.t.bodySmall
                                                ?.copyWith(
                                                    color:
                                                        AppColors.whiteColor),
                                          ),
                                        );
                                      }));
                                },
                                child: Center(
                                  child: Text(
                                    verificationController.isTwoFactorEnabled
                                        ? storedLanguage[
                                                'Disabloe Two Factor Authenticator'] ??
                                            "Disable Two Factor Authenticator"
                                        : storedLanguage[
                                                'Enable Two Factor Authenticator'] ??
                                            "Enable Two Factor Authenticator",
                                    style: context.t.bodyLarge
                                        ?.copyWith(color: AppColors.whiteColor),
                                  ),
                                ),
                              ),
                            ),
                            VSpace(32.h),
                            Text(
                                storedLanguage['Google Authenticator'] ??
                                    "Google Authenticator",
                                style: context.t.bodyLarge),
                            VSpace(8.h),
                            const Divider(color: AppColors.black10),
                            VSpace(12.h),
                            Text(
                              "Use Google Authenticator to Scan The QR code or use the code",
                              style: context.t.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                            VSpace(12.h),
                            Text(
                              "Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the Two-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device.",
                              style: context.t.bodyMedium?.copyWith(
                                  color: Get.isDarkMode
                                      ? AppColors.black20
                                      : AppColors.black50),
                            ),
                            VSpace(50.h),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
