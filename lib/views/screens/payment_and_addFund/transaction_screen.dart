import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/transaction_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/search_dialog.dart';
import '../../widgets/spacing.dart';

class TransactionScreen extends StatelessWidget {
  final bool? isFromHomePage;
  const TransactionScreen({super.key, this.isFromHomePage = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<TransactionController>(builder: (transactionCtrl) {
      return Scaffold(
        appBar: buildAppbar(
            storedLanguage, context, transactionCtrl, isFromHomePage),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: AppColors.mainColor,
          onRefresh: () async {
            await transactionCtrl.getTransactionList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  CustomTextField(
                    height: 45.h,
                    isPrefixIcon: true,
                    isSuffixIcon: true,
                    isSuffixBgColor: true,
                    prefixIcon: 'search',
                    suffixIcon: 'filter',
                    hintext: 'ابحث عن طريق الاسم',
                    onChanged: (v) {
                      transactionCtrl.filterCenterModels(v);
                    },
                    controller: transactionCtrl.transactionIdEditingCtrlr,
                  ),

                  VSpace(20.h),
                  transactionCtrl.isLoading
                      ? Helpers.appLoader()
                      : transactionCtrl.filteredCenterModels.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: transactionCtrl.filteredCenterModels.length,
                              itemBuilder: (context, i) {
                                var clampedIndex = i.clamp(0,
                                    transactionCtrl.filteredCenterModels.length - 1);
                                var data = transactionCtrl
                                    .filteredCenterModels[clampedIndex];

                                return Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 14.h),
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  decoration: BoxDecoration(
                                    color: AppThemes.getFillColor(),
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                        color: AppColors.mainColor, width: 0.2),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40.h,
                                        height: 40.h,
                                        padding: EdgeInsets.all(8.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          color: data.color == 'success'
                                              ? AppColors.greenColor
                                                  .withOpacity(0.1)
                                              : AppColors.redColor
                                                  .withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            data.color == 'success'
                                                ? "$rootImageDir/arrow_bottom.png"
                                                : "$rootImageDir/arrow_top.png",
                                            color: data.color == 'success'
                                                ? AppColors.greenColor
                                                : AppColors.redColor,
                                            width: 20.h,
                                            height: 20.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        flex: 10,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data.arabicName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: t.bodyMedium
                                                  ?.copyWith(fontSize: 14.sp),
                                            ),
                                            SizedBox(height: 3.h),
                                            Text(
                                              DateFormat('dd MMM yyyy hh:mm a')
                                                  .format(DateTime.parse(
                                                      data.createdDate)),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: t.bodySmall?.copyWith(
                                                fontSize: 12.sp,
                                                color:
                                                    AppThemes.getBlack50Color(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Flexible(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "${data.result}", // Adjust based on your data field
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: t.bodyMedium?.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.redColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  CustomAppBar buildAppbar(storedLanguage, BuildContext context,
      TransactionController transactionCtrl, isFromHomePage) {
    return CustomAppBar(
      title:  "المعاملات",
      // toolberHeight: 100.h,
      // prefferSized: 100.h,
      leading: isFromHomePage == true
          ? IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Container(
                width: 34.h,
                height: 34.h,
                padding: EdgeInsets.all(10.5.h),
                decoration: BoxDecoration(
                  color:
                      Get.isDarkMode ? AppColors.darkBgColor : AppColors.black5,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.mainColor, width: .2),
                ),
                child: Image.asset(
                  "$rootImageDir/back.png",
                  height: 24.h,
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ))
          : const SizedBox(),
      actions: [

      ],
    );
  }
}
