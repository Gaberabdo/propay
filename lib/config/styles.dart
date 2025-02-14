import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class Styles {
  static const String appFontFamily = 'Poppins';

  static TextStyle baseStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
  static TextStyle mediumTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 24,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static TextStyle smallTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 22,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bodyLarge = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bodyMedium = TextStyle(
    color: AppColors.blackColor,
    fontSize: 16,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bodySmall = TextStyle(
    color: AppColors.black50,
    fontSize: 14,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
}
