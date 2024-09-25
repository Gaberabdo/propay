import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/utils/services/localstorage/hive.dart';
import 'package:gamers_arena/utils/services/localstorage/keys.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../widgets/app_button.dart';
import '../../widgets/spacing.dart';
import 'onbording_data.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: onBordingDataList.length,
                onPageChanged: (i) {
                  setState(() {
                    currentIndex = i;
                  });
                },
                itemBuilder: (context, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        onBordingDataList[i].imagePath,
                        height: 385.h,
                        fit: BoxFit.cover,
                      ),
                      VSpace(59.h),
                      Center(
                        child: Text(
                          onBordingDataList[i].title,
                          style: t.titleMedium?.copyWith(fontSize: 24.sp),
                        ),
                      ),
                      VSpace(12.h),
                      Center(
                        child: Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Text(
                            onBordingDataList[i].description,
                            textAlign: TextAlign.center,
                            style: t.displayMedium?.copyWith(
                                height: 1.5,
                                fontSize: 16.sp,
                                color: Get.isDarkMode
                                    ? AppColors.black30
                                    : AppColors.black50),
                          ),
                        ),
                      ),
                      VSpace(44.h),
                      SmoothPageIndicator(
                        controller: controller,
                        count: onBordingDataList.length,
                        axisDirection: Axis.horizontal,
                        effect: ExpandingDotsEffect(
                          dotColor: AppColors.black10,
                          dotHeight: 10.h,
                          dotWidth: 10.h,
                          activeDotColor: AppColors.mainColor,
                        ),
                      )
                    ],
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.h),
          padding: Dimensions.kDefaultPadding,
          child: Row(
            mainAxisAlignment: (currentIndex == onBordingDataList.length - 1)
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              currentIndex == onBordingDataList.length - 1
                  ? const SizedBox(
                      height: 1,
                      width: 1,
                    )
                  : InkWell(
                      onTap: () {
                        controller.animateToPage(
                          onBordingDataList.length,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOutQuint,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          storedLanguage['Skip'] ?? "تخطي",
                          style: t.displayMedium?.copyWith(
                            color: AppColors.greyColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
              AppButton(
                text: (currentIndex == onBordingDataList.length - 1)
                    ? (storedLanguage['Get Started'] ?? "البدء")
                    : (storedLanguage['Next'] ?? "التالي"),
                onTap: () {
                  (currentIndex == (onBordingDataList.length - 1))
                      ? Get.offAllNamed(RoutesName.loginScreen)
                      : controller.nextPage(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOutQuint,
                        );
                  if (currentIndex == onBordingDataList.length - 1) {
                    HiveHelp.write(Keys.isNewUser, false);
                  }
                },
                buttonWidth: (currentIndex == onBordingDataList.length - 1)
                    ? 142.h
                    : 100.h,
                buttonHeight: (currentIndex == onBordingDataList.length - 1)
                    ? 42.h
                    : 36.h,
                style: t.displayMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
