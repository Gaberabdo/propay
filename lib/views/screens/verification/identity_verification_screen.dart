import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/themes/themes.dart';
import 'package:gamers_arena/views/widgets/app_button.dart';
import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/verification_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class IdentityVerificationScreen extends StatelessWidget {
  const IdentityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};

    Get.find<VerificationController>()
        .refreshIndentityVerificationDynamicData();
    return GetBuilder<VerificationController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Identity Verification'] ??
              'Identity Verification',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Form(
                  key: _.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _.isLoading
                          ? Helpers.appLoader()
                          : _.userIdentityVerifyFromShow == false
                              ? Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 100.h),
                                        height: 160.h,
                                        width: 160.h,
                                        padding: EdgeInsets.all(25.h),
                                        decoration: BoxDecoration(
                                          color:
                                              Get.find<VerificationController>()
                                                      .userIdentityVerifyMsg
                                                      .toLowerCase()
                                                      .contains('pending')
                                                  ? AppColors.mainColor
                                                      .withOpacity(.2)
                                                  : AppColors.greenColor
                                                      .withOpacity(.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          Get.find<VerificationController>()
                                                  .userIdentityVerifyMsg
                                                  .toLowerCase()
                                                  .contains('pending')
                                              ? '$rootImageDir/pending.png'
                                              : '$rootImageDir/approved.png',
                                          color:
                                              Get.find<VerificationController>()
                                                      .userIdentityVerifyMsg
                                                      .toLowerCase()
                                                      .contains('pending')
                                                  ? AppColors.mainColor
                                                  : AppColors.greenColor,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      VSpace(20.h),
                                      Text(
                                          Get.find<VerificationController>()
                                              .userIdentityVerifyMsg,
                                          style: context.t.bodyMedium?.copyWith(
                                              color: Get.find<
                                                          VerificationController>()
                                                      .userIdentityVerifyMsg
                                                      .toLowerCase()
                                                      .contains('pending')
                                                  ? Get.isDarkMode
                                                      ? AppColors.whiteColor
                                                      : AppColors.blackColor
                                                  : AppColors.greenColor)),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _.categoryNameList.length,
                                  itemBuilder: (context, i) {
                                    var data = _.categoryNameList[i];
                                    return RadioListTile(
                                      title: Text(
                                        data.categoryName!,
                                        style: context.t.bodyLarge,
                                      ),
                                      value: data.categoryName,
                                      groupValue: _.selectedOption,
                                      onChanged: _.onChanged,
                                      activeColor: AppColors.mainColor,
                                    );
                                  }),
                      SizedBox(
                        height: 12.h,
                      ),
                      if (_.selectedCategoryDynamicList.isNotEmpty) ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _.selectedCategoryDynamicList.length,
                          itemBuilder: (context, index) {
                            final dynamicField =
                                _.selectedCategoryDynamicList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (dynamicField.servicesForm!.type == "file")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField
                                                .servicesForm!.fieldLevel!,
                                            style: context.t.bodyLarge,
                                          ),
                                          dynamicField.servicesForm!
                                                      .validation ==
                                                  'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Container(
                                        height: 45.5,
                                        width: double.maxFinite,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          color: AppThemes.getFillColor(),
                                          borderRadius:
                                              BorderRadius.circular(34.r),
                                          border: Border.all(
                                              color: AppColors.mainColor,
                                              width: .2),
                                        ),
                                        child: Row(
                                          children: [
                                            HSpace(12.w),
                                            Text(
                                              _.imagePickerResults[dynamicField
                                                          .servicesForm!
                                                          .fieldName] !=
                                                      null
                                                  ? storedLanguage[
                                                          '1 File selected'] ??
                                                      "1 File selected"
                                                  : storedLanguage[
                                                          'No File selected'] ??
                                                      "No File selected",
                                              style: context.t.bodySmall?.copyWith(
                                                  color: _.imagePickerResults[
                                                              dynamicField
                                                                  .servicesForm!
                                                                  .fieldName] !=
                                                          null
                                                      ? AppColors.greenColor
                                                      : AppColors.black60),
                                            ),
                                            const Spacer(),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  Helpers.hideKeyboard();

                                                  await _.pickFile(dynamicField
                                                      .servicesForm!
                                                      .fieldName!);
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(24.r),
                                                child: Ink(
                                                  width: 113.w,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.r),
                                                    border: Border.all(
                                                        color:
                                                            AppColors.mainColor,
                                                        width: .2),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                          storedLanguage[
                                                                  'Choose File'] ??
                                                              'Choose File',
                                                          style: context
                                                              .t.bodySmall
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
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.servicesForm!.type == "text")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField
                                                .servicesForm!.fieldLevel!,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.servicesForm!
                                                      .validation ==
                                                  'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          // Perform validation based on the 'validation' property
                                          if (dynamicField.servicesForm!
                                                      .validation ==
                                                  "required" &&
                                              value!.isEmpty) {
                                            return storedLanguage[
                                                    'Field is required'] ??
                                                "Field is required";
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          _
                                              .textEditingControllerMap[
                                                  dynamicField
                                                      .servicesForm!.fieldName]!
                                              .text = v;
                                        },
                                        controller: _.textEditingControllerMap[
                                            dynamicField
                                                .servicesForm!.fieldName],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 16),
                                          filled:
                                              true, // Fill the background with color
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),
                                          fillColor: AppThemes
                                              .getFillColor(), // Background color
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.mainColor,
                                              width: .2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(34.r),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(34.r),
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                          ),
                                        ),
                                        style: context.t.bodyMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.servicesForm!.type ==
                                    'textarea')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField
                                                .servicesForm!.fieldLevel!,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.servicesForm!
                                                      .validation ==
                                                  'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (dynamicField.servicesForm!
                                                      .validation ==
                                                  "required" &&
                                              value!.isEmpty) {
                                            return storedLanguage[
                                                    'Field is required'] ??
                                                "Field is required";
                                          }
                                          return null;
                                        },
                                        controller: _.textEditingControllerMap[
                                            dynamicField
                                                .servicesForm!.fieldName],
                                        maxLines: 7,
                                        minLines: 5,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 16),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),
                                          fillColor: AppThemes
                                              .getFillColor(), // Background color
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                            borderSide: BorderSide(
                                              color: AppColors.mainColor,
                                              width: .2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                          ),
                                        ),
                                        style: context.t.bodyMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                      SizedBox(
                        height: 12.h,
                      ),
                      _.selectedOption.isEmpty
                          ? SizedBox()
                          : AppButton(
                              isLoading: _.isIdentitySubmitting ? true : false,
                              text: storedLanguage['Submit'] ?? 'Submit',
                              onTap: () async {
                                Helpers.hideKeyboard();
                                if (_.formKey.currentState!.validate() &&
                                    _.requiredTypeFileList.isEmpty) {
                                  await _.renderDynamicFieldData();

                                  Map<String, String> stringMap = {};
                                  _.dynamicData.forEach((key, value) {
                                    if (value is String) {
                                      stringMap[key] = value;
                                    }
                                  });

                                  await Future.delayed(
                                      Duration(milliseconds: 300));

                                  Map<String, String> body = {
                                    "identity_type": _.identityType,
                                  };
                                  body.addAll(stringMap);

                                  await _
                                      .submitVerification(
                                          fields: body,
                                          fileList: _.fileMap.entries
                                              .map((e) => e.value)
                                              .toList(),
                                          context: context)
                                      .then((value) {});
                                } else {
                                  print(
                                      "required type file list===========================: $_.requiredTypeFileList");
                                  Helpers.showSnackBar(
                                      msg:
                                          "Please fill in all required fields.");
                                }
                              }),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
