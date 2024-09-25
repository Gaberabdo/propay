import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/app_controller.dart';
import 'package:gamers_arena/controllers/profile_controller.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:gamers_arena/utils/services/localstorage/hive.dart';
import 'package:gamers_arena/utils/services/localstorage/keys.dart';
import 'package:gamers_arena/views/widgets/app_button.dart';
import 'package:gamers_arena/views/widgets/mediaquery_extension.dart';
import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../data/models/language_model.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

// تجاهل: يجب أن تكون غير قابلة للتغيير
class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  var selectedLanguageVal;

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.find<ProfileController>().isLanguageSelected = false;
    return GetBuilder<ProfileController>(builder: (profileController) {
      return GetBuilder<AppController>(builder: (appController) {
        var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
        return Scaffold(
          backgroundColor: Get.isDarkMode
              ? AppColors.darkCardColor
              : AppColors.fillColorColor,
          appBar: CustomAppBar(
            bgColor: Get.isDarkMode
                ? AppColors.darkCardColor
                : AppColors.fillColorColor,
            isReverseIconBgColor: true,
            title: storedLanguage['تعديل الملف الشخصي'] ?? "تعديل الملف الشخصي",
          ),
          body: RefreshIndicator(
            color: AppColors.mainColor,
            onRefresh: () async {
              await profileController.getProfile();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.screenHeight * .1,
                  ),
                  Container(
                    height: Dimensions.screenHeight,
                    width: double.maxFinite,
                    padding: Dimensions.kDefaultPadding,
                    decoration: BoxDecoration(
                      color: AppThemes.getDarkBgColor(),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r)),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -Dimensions.screenHeight * .07,
                          child: GestureDetector(
                            onTap: () {
                              if (Get.find<ProfileController>().userPhoto !=
                                  '') {
                                Get.to(() => Scaffold(
                                    appBar: const CustomAppBar(title: ""),
                                    body: PhotoView(
                                      imageProvider: NetworkImage(
                                          Get.find<ProfileController>()
                                              .userPhoto),
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
                                  image:
                                  Get.find<ProfileController>().isLoading ||
                                      Get.find<ProfileController>()
                                          .userPhoto ==
                                          ''
                                      ? DecorationImage(
                                    image: AssetImage(
                                      "$rootImageDir/avatar.webp",
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                      : DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      Get.find<ProfileController>()
                                          .userPhoto,
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Positioned(
                          child: profileController.isLoading
                              ? Helpers.appLoader()
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VSpace(70.h),
                              Text(
                                  storedLanguage['الاسم الأول'] ??
                                      "الاسم الأول",
                                  style: t.displayMedium),
                              VSpace(10.h),
                              CustomTextField(
                                height: 50.h,
                                hintext:
                                storedLanguage['أدخل الاسم الأول'] ??
                                    "أدخل الاسم الأول",
                                controller: profileController
                                    .firstNameEditingController,
                                contentPadding:
                                EdgeInsets.only(right: 20.w),
                              ),
                              VSpace(24.h),
                              Text(
                                  storedLanguage['البريد الإلكتروني'] ??
                                      "البريد الإلكتروني",
                                  style: t.displayMedium),
                              VSpace(10.h),
                              CustomTextField(
                                height: 50.h,
                                enabled: false,
                                hintext: storedLanguage[
                                'أدخل البريد الإلكتروني'] ??
                                    "أدخل البريد الإلكتروني",
                                controller: profileController
                                    .emailEditingController,
                                contentPadding:
                                EdgeInsets.only(right: 20.w),
                              ),
                              VSpace(24.h),
                              Text(
                                  storedLanguage['رقم الهاتف'] ??
                                      "رقم الهاتف",
                                  style: t.displayMedium),
                              VSpace(10.h),
                              CustomTextField(
                                height: 50.h,
                                enabled: false,
                                hintext: "أدخل رقم الهاتف",
                                controller: profileController
                                    .phoneNumberEditingController,
                                contentPadding:
                                EdgeInsets.only(right: 20.w),
                              ),
                              VSpace(24.h),
                              Text(storedLanguage['العنوان'] ?? "العنوان",
                                  style: t.displayMedium),
                              VSpace(10.h),
                              CustomTextField(
                                hintext:
                                "أدخل العنوان",
                                controller: profileController
                                    .addressEditingController,
                                contentPadding:
                                EdgeInsets.only(right: 20.w),
                              ),
                              VSpace(24.h),
                              Text(storedLanguage['كلمة المرور الجديدة'] ??
                                  "كلمة المرور الجديدة",
                                  style: t.displayMedium),
                              VSpace(10.h),
                              CustomTextField(
                                hintext:
                                "اتركه فارغًا للاحتفاظ بكلمة المرور الحالية.",
                                controller: profileController
                                    .newPassEditingController,
                                contentPadding:
                                EdgeInsets.only(right: 20.w),
                              ),
                              VSpace(24.h),
                              Material(
                                color: Colors.transparent,
                                child: AppButton(
                                  isLoading: profileController.isUpdateProfile
                                      ? true
                                      : false,
                                  onTap: () async {
                                    Helpers.hideKeyboard();
                                    profileController.updateProfile();
                                  },
                                  text:
                                  storedLanguage['تحديث الملف الشخصي'] ??
                                      'تحديث الملف الشخصي',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
