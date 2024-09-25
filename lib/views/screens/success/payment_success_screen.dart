import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/routes/routes_name.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

Color themeColor = const Color(0xFF43D19E);

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return WillPopScope(
      onWillPop:  () async {
        Get.offAllNamed(RoutesName.bottomNavBar);
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 150.h,
                  padding: EdgeInsets.all(37.h),
                  decoration: BoxDecoration(
                    color: themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/images/card.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  storedLanguage['Thank You!'] ?? "Thank You!",
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 36.sp,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  storedLanguage['Payment done successfully'] ??
                      "Payment done successfully.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17.sp,
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                InkWell(
                  onTap: () {
                    Get.offAllNamed(RoutesName.bottomNavBar);
                  },
                  child: Container(
                    height: 45.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(32)),
                    child: Center(
                        child: Text(
                      storedLanguage['Go Home'] ?? "Go Home",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
