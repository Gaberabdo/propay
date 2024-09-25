import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/views/widgets/spacing.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../themes/themes.dart';
import '../../utils/app_constants.dart';
import 'app_textfield.dart';

class CustomTextField extends StatelessWidget {
  final bool? isPrefixIcon;
  final bool? isSuffixIcon;
  final String hintext;
  final String? prefixIcon;
  final String? suffixIcon;
  final dynamic Function(String)? onChanged;
  final TextEditingController controller;
  final Color? bgColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final double? suffixIconSize;
  final double? preffixIconSize;
  final BoxFit? suffixFit;
  final EdgeInsetsGeometry? contentPadding;
  final AlignmentGeometry? alignment;
  final void Function()? onPreffixPressed;
  final void Function()? onSuffixPressed;
  final bool? obsCureText;
  final bool? isSuffixBgColor;
  final bool? isReverseColor;
  final bool? isBorderColor;
  final FocusNode? focusNode;
  final bool enabled;

  const CustomTextField(
      {super.key,
      this.isPrefixIcon = false,
      this.isSuffixIcon = false,
      required this.hintext,
      required this.controller,
      this.onChanged,
        this.enabled = true,

        this.bgColor,
      this.keyboardType = TextInputType.text,
      this.inputFormatters,
      this.height,
      this.minLines,
      this.maxLines,
      this.contentPadding,
      this.focusNode,
      this.obsCureText = false,
      this.isSuffixBgColor = false,
      this.alignment,
      this.prefixIcon,
      this.suffixIcon,
      this.onPreffixPressed,
      this.onSuffixPressed,
      this.isReverseColor = false,
      this.isBorderColor = true,
      this.suffixIconSize, this.preffixIconSize, this.suffixFit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50.h,
      alignment: alignment ?? Alignment.center,
      decoration: BoxDecoration(
        color: bgColor == null
            ? isReverseColor == true
                ? Get.isDarkMode
                    ? AppColors.darkBgColor
                    : AppColors.fillColorColor
                : AppThemes.getFillColor()
            : this.bgColor,
        borderRadius: Dimensions.kBorderRadius,
        border: Border.all(
            color: isBorderColor == true
                ? AppColors.mainColor
                : Colors.transparent,
            width: .2),
      ),
      child: Row(
        children: [
          HSpace(isPrefixIcon == true ? 20.w : 0),
          isPrefixIcon == true
              ? InkResponse(
                  onTap: onPreffixPressed,
                  child: Image.asset(
                    "$rootImageDir/$prefixIcon.png",
                    height: preffixIconSize ?? 16.h,
                    width: preffixIconSize ?? 16.h,
                    color: Get.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.textFieldHintColor,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
          Expanded(
            child: AppTextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obsCureText ?? false,
              minLines: minLines ?? 1,
              maxLines: maxLines ?? 1,
              enabled:enabled,
              hinText: hintext,
              onChanged: onChanged,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              contentPadding: contentPadding ?? EdgeInsets.only(left: 10.w,right: 10.w),
            ),
          ),
          HSpace(isSuffixIcon == true ? 10.w : 0),
          isSuffixIcon == true
              ? Padding(
                  padding: isSuffixBgColor == true
                      ? EdgeInsets.all(3.h)
                      : EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSuffixBgColor == true
                          ? Get.isDarkMode
                              ? AppColors.darkBgColor
                              : AppColors.whiteColor
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        onPressed: onSuffixPressed,
                        icon: Image.asset(
                          "$rootImageDir/$suffixIcon.png",
                          height: suffixIconSize ?? 20.h,
                          width: suffixIconSize ?? 20.h,
                          color: Get.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.textFieldHintColor,
                          fit: suffixFit ?? BoxFit.cover,
                        )),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
