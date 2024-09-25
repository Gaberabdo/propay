import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/topup_order_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class TopupOrderScreen extends StatelessWidget {
  const TopupOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
            var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<TopupOrderController>(builder: (topupOrderCtrl) {
      return Scaffold(
        appBar: CustomAppBar(title:storedLanguage['Topup Order'] ?? "Topup Order"),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            topupOrderCtrl.resetDataAfterSearching(
                isFromOnRefreshIndicator: true);
            await topupOrderCtrl.getTopupOrderList(page: 1);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: topupOrderCtrl.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(20.h),
                  topupOrderCtrl.isLoading
                      ? Helpers.appLoader()
                      : topupOrderCtrl.topupOrderList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: topupOrderCtrl.topupOrderList.length,
                              itemBuilder: (context, i) {
                                var data = topupOrderCtrl.topupOrderList[i];
                                return Padding(
                                  padding:EdgeInsets.only(bottom: 12.h),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(16.r),
                                    onTap: () {
                                      appDialog(
                                          context: context,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkResponse(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(7.h),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppThemes.getFillColor(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 14.h,
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                "$rootImageDir/done.png",
                                                height: 48.h,
                                                width: 48.h,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                data.category ?? '',
                                                style: t.bodyLarge
                                                    ?.copyWith(fontSize: 22.sp),
                                              ),
                                              VSpace(22.h),
                                              Text(
                                               storedLanguage['Category'] ?? "Category",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.category ?? '',
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              InkWell(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .removeCurrentSnackBar();
                                                  Clipboard.setData(
                                                      new ClipboardData(
                                                          text:
                                                              "${data.trx ?? ''}"));
                                  
                                                  Helpers.showSnackBar(
                                                      msg: "Copied Successfully",
                                                      title: 'Success',
                                                      bgColor:
                                                          AppColors.greenColor);
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                       storedLanguage['Transaction ID'] ?? "Transaction ID",
                                                        style: t.bodyMedium?.copyWith(
                                                            color: Get.isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor
                                                                    .withOpacity(
                                                                        .5)),
                                                      ),
                                                      Text(
                                                        data.trx ?? '',
                                                        style: t.bodySmall,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                               storedLanguage['Price'] ?? "Price",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.price + " ${data.currency}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Service'] ??"Service",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.service ?? '',
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                              storedLanguage['Date and Time'] ??  "Date and Time",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                DateFormat('dd MMM yyyy hh:mm a')
                                                    .format(DateTime.parse(
                                                        data.dateTime)),
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                            ],
                                          ));
                                    },
                                    child: Ink(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 14.h),
                                  
                                      decoration: BoxDecoration(
                                        color: AppThemes.getFillColor(),
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(
                                            color: AppColors.mainColor,
                                            width: .2),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40.h,
                                            height: 40.h,
                                            padding: EdgeInsets.all(10.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              color: checkStatusBorderColor(
                                                      data.status)
                                                  .withOpacity(.1),
                                              border: Border.all(
                                                  color: checkStatusBorderColor(
                                                      data.status),
                                                  width: .2),
                                            ),
                                            child: Image.asset(
                                              checkStatusIcon(data.status),
                                              color:
                                                  checkStatusColor(data.status),
                                            ),
                                          ),
                                          HSpace(12.w),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  data.category ?? '',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  style: t.bodyMedium,
                                                ),
                                                VSpace(3.h),
                                                Text(
                                                  DateFormat(
                                                          'dd MMM yyyy hh:mm a')
                                                      .format(DateTime.parse(
                                                          data.dateTime)),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: t.bodySmall?.copyWith(
                                                      color: AppThemes
                                                          .getBlack50Color()),
                                                ),
                                              ],
                                            ),
                                          ),
                                          HSpace(3.w),
                                          Expanded(
                                            flex: 2,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                data.symbol + "${data.price}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodyMedium?.copyWith(
                                                    fontSize: 14.sp,
                                                    color: checkStatusColor(
                                                        data.status)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                  if (topupOrderCtrl.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader()),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  checkStatusColor(dynamic status) {
    if (status == "Complete") {
      return AppColors.greenColor;
    } else if (status == "Pending") {
      return AppColors.pendingColor;
    } else {
      return AppColors.redColor;
    }
  }

  checkStatusBorderColor(dynamic status) {
    if (status == "Complete") {
      return AppColors.greenColor;
    } else if (status == "Pending") {
      return AppColors.pendingColor;
    } else {
      return AppColors.redColor;
    }
  }

  checkStatusIcon(dynamic status) {
    if (status == "Complete") {
      return "$rootImageDir/approved.png";
    } else if (status == "Pending") {
      return "$rootImageDir/pending.png";
    } else {
      return "$rootImageDir/rejected.png";
    }
  }
}
