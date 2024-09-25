import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/profile_controller.dart';
import 'package:gamers_arena/themes/themes.dart';
import 'package:gamers_arena/views/widgets/app_button.dart';
import 'package:gamers_arena/views/widgets/custom_appbar.dart';
import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/verification_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/spacing.dart';

class AddressVerificationScreen extends StatelessWidget {
  const AddressVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ProfileController>(builder: (_) {
      return GetBuilder<VerificationController>(builder: (_) {
        return Scaffold(
          appBar: CustomAppBar(
            title: storedLanguage['Address Verification'] ??
                'Address Verification',
          ),
          body: Column(
            children: [
              VSpace(20.h),
              Get.find<ProfileController>().isLoading
                  ? Helpers.appLoader()
                  : Get.find<ProfileController>()
                          .addressVerificationMsg
                          .toLowerCase()
                          .contains('pending')
                      ? Center(
                          child: Column(
                            children: [
                              Container(
                                height: 160.h,
                                width: 160.h,
                                margin: EdgeInsets.only(top: 100.h),
                                padding: EdgeInsets.all(25.h),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor.withOpacity(.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  '$rootImageDir/pending.png',
                                  color: AppColors.mainColor,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              VSpace(20.h),
                              Text(
                                  Get.find<ProfileController>()
                                      .addressVerificationMsg,
                                  style: context.t.bodyMedium),
                            ],
                          ),
                        )
                      : Get.find<ProfileController>()
                              .addressVerificationMsg
                              .toLowerCase()
                              .contains('verified')
                          ? Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 160.h,
                                    width: 160.h,
                                    margin: EdgeInsets.only(top: 100.h),
                                    padding: EdgeInsets.all(15.h),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.greenColor.withOpacity(.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      '$rootImageDir/approved.png',
                                      color: AppColors.greenColor,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  VSpace(20.h),
                                  Text(
                                      Get.find<ProfileController>()
                                          .addressVerificationMsg,
                                      style: context.t.bodyMedium?.copyWith(
                                          color: AppColors.greenColor)),
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32.w, vertical: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    storedLanguage['Address Proof'] ??
                                        "Address Proof",
                                    style: context.t.bodyLarge,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Container(
                                    height: 45.5,
                                    width: double.maxFinite,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      color: AppThemes.getFillColor(),
                                      borderRadius: BorderRadius.circular(34.r),
                                      border: Border.all(
                                          color: AppColors.mainColor,
                                          width: .2),
                                    ),
                                    child: Row(
                                      children: [
                                        HSpace(12.w),
                                        Text(
                                          _.imagePath.isNotEmpty
                                              ? storedLanguage[
                                                      '1 File Selected'] ??
                                                  '1 File Selected'
                                              : storedLanguage[
                                                      'No File Chosen'] ??
                                                  'No File Chosen',
                                          style: context.t.bodySmall?.copyWith(
                                              color: _.imagePath.isNotEmpty
                                                  ? AppColors.greenColor
                                                  : AppColors.black30),
                                        ),
                                        const Spacer(),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              _.pickFiles();
                                            },
                                            borderRadius:
                                                BorderRadius.circular(24.r),
                                            child: Ink(
                                              width: 113.w,
                                              decoration: BoxDecoration(
                                                color: AppColors.mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(24.r),
                                                border: Border.all(
                                                    color: AppColors.mainColor,
                                                    width: .2),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                      storedLanguage[
                                                              'Choose File'] ??
                                                          'Choose File',
                                                      style: context.t.bodySmall
                                                          ?.copyWith(
                                                              color: AppColors
                                                                  .whiteColor))),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35.h,
                                  ),
                                  AppButton(
                                    isLoading:
                                        Get.find<VerificationController>()
                                                .isLoading
                                            ? true
                                            : false,
                                    onTap: Get.find<VerificationController>()
                                            .isLoading
                                        ? null
                                        : () async {
                                            if (_.imagePath.isEmpty) {
                                              Helpers.showSnackBar(
                                                msg:
                                                    "Please Select a file first",
                                              );
                                            } else {
                                              await Get.find<
                                                      VerificationController>()
                                                  .addressVerify(
                                                      filePath: _.imagePath,
                                                      context: context);
                                            }
                                          },
                                    text: storedLanguage['Submit'] ?? 'Submit',
                                  ),
                                ],
                              ),
                            ),
            ],
          ),
        );
      });
    });
  }
}
