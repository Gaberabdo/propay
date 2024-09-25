import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/views/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/voucher_order_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_dialog.dart';
import '../../widgets/spacing.dart';

class VoucherOrderScreen extends StatelessWidget {
  const VoucherOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<VoucherOrderController>(builder: (voucherOrderCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Voucher Order'] ?? "Voucher Order",
          actions: [
            InkResponse(
              onTap: () {
                searchDialog(
                    context: context,
                    transaction: voucherOrderCtrl.transactionIdEditingCtrlr,
                    isRemarkField: false,
                    date: voucherOrderCtrl.dateTimeEditingCtrlr,
                    onDatePressed: () async {
                      /// SHOW DATE PICKER
                      await showDatePicker(
                              context: context,
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                        background: AppColors.bgColor,
                                        onPrimary: AppColors.whiteColor,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppColors
                                              .mainColor, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!);
                              },
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025))
                          .then((value) {
                        if (value != null) {
                          print(value.toUtc());
                          voucherOrderCtrl.dateTimeEditingCtrlr.text =
                              DateFormat('yyyy-MM-dd').format(value);
                        }
                      });
                    },
                    onSearchPressed: () async {
                      voucherOrderCtrl.resetDataAfterSearching();
                      Get.back();
                      await voucherOrderCtrl
                          .getVoucherOrderList(
                        page: 1,
                        transaction_id:
                            "${voucherOrderCtrl.transactionIdEditingCtrlr.text}",
                        date: voucherOrderCtrl.dateTimeEditingCtrlr.text,
                      )
                          .then((value) {
                        voucherOrderCtrl.dateTimeEditingCtrlr.clear();
                        voucherOrderCtrl.transactionIdEditingCtrlr.clear();
                      });
                    });
              },
              child: Container(
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
                  "$rootImageDir/filter_3.png",
                  height: 32.h,
                  width: 32.h,
                  color: Get.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            HSpace(20.w),
          ],
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            voucherOrderCtrl.resetDataAfterSearching(
                isFromOnRefreshIndicator: true);
            await voucherOrderCtrl.getVoucherOrderList(
                page: 1, transaction_id: '', date: '');
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: voucherOrderCtrl.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(20.h),
                  voucherOrderCtrl.isLoading
                      ? Helpers.appLoader()
                      : voucherOrderCtrl.voucherOrderList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  voucherOrderCtrl.voucherOrderList.length,
                              itemBuilder: (context, i) {
                                var data = voucherOrderCtrl.voucherOrderList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16.r),
                                    onTap: () {
                                      List<bool> voucherBoolList = [];
                                      voucherBoolList = List.generate(
                                          data.voucherCode!.length,
                                          (index) => true);
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
                                                    color: AppThemes
                                                        .getFillColor(),
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
                                                data.voucher ?? '',
                                                style: t.bodyLarge
                                                    ?.copyWith(fontSize: 22.sp),
                                              ),
                                              VSpace(22.h),
                                              Text(
                                                storedLanguage['Voucher'] ??
                                                    "Voucher",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.voucher ?? '',
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
                                                      msg:
                                                          "Copied Successfully",
                                                      title: 'Success',
                                                      bgColor:
                                                          AppColors.greenColor);
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        storedLanguage[
                                                                'Transaction ID'] ??
                                                            "Transaction ID",
                                                        style: t.bodyMedium?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
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
                                                storedLanguage['Price'] ??
                                                    "Price",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.price +
                                                    " ${data.currency}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Service'] ??
                                                    "Service",
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
                                                storedLanguage[
                                                        'Date and Time'] ??
                                                    "Date and Time",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                DateFormat(
                                                        'dd MMM yyyy hh:mm a')
                                                    .format(data.dateTime!),
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage[
                                                        'Voucher Code'] ??
                                                    "Voucher Code",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              VSpace(5.h),
                                              ...List.generate(
                                                  data.voucherCode!.length,
                                                  (index) => GetBuilder<
                                                              VoucherOrderController>(
                                                          builder: (_) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10.h),
                                                          child:
                                                              CustomTextField(
                                                            height: 45.h,
                                                            hintext: "",
                                                            isSuffixIcon: true,
                                                            isPrefixIcon: true,
                                                            obsCureText:
                                                                voucherBoolList[
                                                                            index] ==
                                                                        true
                                                                    ? true
                                                                    : false,
                                                            prefixIcon:
                                                                voucherBoolList[
                                                                            index] ==
                                                                        true
                                                                    ? 'hide'
                                                                    : 'show',
                                                            suffixIcon: 'copy',
                                                            suffixFit: BoxFit
                                                                .fitHeight,
                                                            suffixIconSize:
                                                                14.h,
                                                            preffixIconSize:
                                                                18.h,
                                                            controller: TextEditingController(
                                                                text: data
                                                                    .voucherCode![
                                                                        index]
                                                                    .toString()),
                                                            onPreffixPressed:
                                                                () {
                                                              voucherBoolList[
                                                                      index] =
                                                                  !voucherBoolList[
                                                                      index];
                                                              _.update();
                                                            },
                                                            onSuffixPressed:
                                                                () {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .removeCurrentSnackBar();
                                                              Clipboard.setData(
                                                                  new ClipboardData(
                                                                      text:
                                                                          "${data.voucherCode![index] ?? ''}"));

                                                              Helpers.showSnackBar(
                                                                  msg:
                                                                      "Copied Successfully",
                                                                  title:
                                                                      'Success',
                                                                  bgColor: AppColors
                                                                      .greenColor);
                                                            },
                                                          ),
                                                        );
                                                      })),
                                            ],
                                          ));
                                    },
                                    child: Ink(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 14.h),
                                      decoration: BoxDecoration(
                                        color: AppThemes.getFillColor(),
                                        borderRadius:
                                            BorderRadius.circular(16.r),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  data.voucher ?? '',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  style: t.bodyMedium,
                                                ),
                                                VSpace(3.h),
                                                Text(
                                                  DateFormat(
                                                          'dd MMM yyyy hh:mm a')
                                                      .format(data.dateTime!),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                  if (voucherOrderCtrl.isLoadMore == true)
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
