import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../config/styles.dart';

class AppThemes {
  //---------------CUSTOM THEME COLOR IN LIGHT AND DARK MODE---------//
  static getIconBlackColor() {
    return Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
  }

  static getGreyColor() {
    return Get.isDarkMode ? AppColors.whiteColor : AppColors.greyColor;
  }

  static getHintColor() {
    return Get.isDarkMode ? AppColors.whiteColor : AppColors.textFieldHintColor;
  }

  static getDarkCardColor() {
    return Get.isDarkMode ? AppColors.darkCardColor : AppColors.whiteColor;
  }

  static getDarkBgColor() {
    return Get.isDarkMode ? AppColors.darkBgColor : AppColors.whiteColor;
  }

  static getBlack10Color() {
    return Get.isDarkMode ? AppColors.darkCardColor : AppColors.black10;
  }

  static getBlack20Color() {
    return Get.isDarkMode ? AppColors.black30 : AppColors.black20;
  }

  static getBlack50Color() {
    return Get.isDarkMode ? AppColors.black30 : AppColors.black50;
  }

  static getFillColor() {
    return Get.isDarkMode ? AppColors.darkCardColor : AppColors.fillColorColor;
  }

  static getInactiveColor() {
    return Get.isDarkMode
        ? AppColors.darkCardColor
        : AppColors.textFieldHintColor;
  }

  //---------------------------------//
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.whiteColor,
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.whiteColor),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
    ),
    dialogBackgroundColor: AppColors.whiteColor,
    iconTheme: const IconThemeData(
      color: AppColors.blackColor,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.whiteColor),
    textTheme: TextTheme(
      displayMedium: Styles.baseStyle.copyWith(fontSize: 16),
      titleSmall: Styles.smallTitle.copyWith(fontSize: 22),
      titleMedium: Styles.mediumTitle.copyWith(fontSize: 24),
      bodyLarge: Styles.bodyLarge.copyWith(fontSize: 18),
      bodyMedium: Styles.bodyMedium.copyWith(fontSize: 16),
      bodySmall: Styles.bodySmall.copyWith(fontSize: 14),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.mainColor.withOpacity(.4),
      cursorColor: AppColors.mainColor.withOpacity(.4),
      selectionHandleColor: AppColors.mainColor.withOpacity(0.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: Styles.baseStyle.copyWith(color: AppColors.textFieldHintColor),
      filled: true,
      fillColor: AppColors.fillColorColor,
      errorBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.redColor), // Error border color
        borderRadius: BorderRadius.circular(6.r), // Border radius
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.redColor), // Error border color
        borderRadius: BorderRadius.circular(6.r),
      ),
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBgColor,
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.darkBgColor),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.darkBgColor,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.whiteColor,
    ),
    dialogBackgroundColor: AppColors.darkCardColor,
    colorScheme: const ColorScheme.dark(primary: AppColors.darkCardColor),
    textTheme: TextTheme(
      displayMedium: Styles.baseStyle.copyWith(color: AppColors.whiteColor,fontSize: 16),
      titleSmall: Styles.smallTitle.copyWith(color: AppColors.whiteColor,fontSize: 22),
      titleMedium: Styles.mediumTitle.copyWith(color: AppColors.whiteColor,fontSize: 24),
      bodyLarge: Styles.bodyLarge.copyWith(color: AppColors.whiteColor,fontSize: 18),
      bodyMedium: Styles.bodyMedium.copyWith(color: AppColors.whiteColor,fontSize: 16),
      bodySmall: Styles.bodySmall.copyWith(color: AppColors.whiteColor,fontSize: 14),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.mainColor.withOpacity(.4),
      cursorColor: AppColors.mainColor.withOpacity(.4),
      selectionHandleColor: AppColors.mainColor.withOpacity(0.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: Styles.baseStyle.copyWith(color: AppColors.textFieldHintColor),
      filled: true,
      fillColor: AppColors.darkCardColor,
      errorBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.redColor), // Error border color
        borderRadius: BorderRadius.circular(6.r), // Border radius
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppColors.redColor), // Error border color
        borderRadius: BorderRadius.circular(6.r),
      ),
    ),
    useMaterial3: true,
  );
}
