import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../utils/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;
  final double? toolberHeight;
  final double? prefferSized;
  final Color? bgColor;
  final bool? isReverseIconBgColor;
  final bool? isTitleMarginTop;
  final double? fontSize;
  const CustomAppBar(
      {super.key,
      this.leading,
      this.actions,
      this.title,
      this.toolberHeight,
      this.prefferSized,
      this.isReverseIconBgColor = false,
      this.isTitleMarginTop = false,
      this.bgColor,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return AppBar(
      toolbarHeight: toolberHeight ?? 100.h,
      backgroundColor: bgColor,
      title: Padding(
        padding: isTitleMarginTop == true
            ? EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h)
            : EdgeInsets.zero,
        child: Text(
          title ?? "",
          style: t.titleMedium?.copyWith(
            fontSize: fontSize ?? 24.sp,
          ),
        ),
      ),
      leading: leading ??
          IconButton(
            padding: EdgeInsets.zero,
              onPressed: () {
                Get.back();
              },
              icon: Container(
                width: 34.h,
                height: 34.h,
                padding: EdgeInsets.all(10.5.h),
                decoration: BoxDecoration(
                  color: isReverseIconBgColor == true
                      ? Get.isDarkMode
                          ? AppColors.darkBgColor
                          : AppColors.black5
                      : Get.isDarkMode
                          ? AppColors.darkCardColor
                          : AppColors.black5,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.mainColor, width: .2),
                ),
                child: Image.asset(
                  "$rootImageDir/back.png",
                  height: 28.h,
                  width: 28.h,
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  fit: BoxFit.fitHeight,
                ),
              )),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefferSized ?? 70.h);
}
