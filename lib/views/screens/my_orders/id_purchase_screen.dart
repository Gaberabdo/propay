import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/config/dimensions.dart';
import 'package:gamers_arena/controllers/id_purchase_controller.dart';
import 'package:gamers_arena/themes/themes.dart';
import 'package:gamers_arena/views/widgets/custom_textfield.dart';
import 'package:gamers_arena/views/widgets/mediaquery_extension.dart';
import 'package:gamers_arena/views/widgets/spacing.dart';
import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_dialog.dart';

class IdPurchaseScreen extends StatelessWidget {
  const IdPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<IdPurchaseController>(builder: (idPurchaseCtrl) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.bgColor,
        appBar: CustomAppBar(
          title: storedLanguage['ID Purchase'] ?? "ID Purchase",
        ),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(20.h),
              CustomTextField(
                height: 45.h,
                isPrefixIcon: true,
                isSuffixBgColor: true,
                isSuffixIcon: true,
                prefixIcon: 'search',
                suffixIcon: 'filter',
                onSuffixPressed: () {
                  searchDialog(
                      context: context,
                      transaction: idPurchaseCtrl.transactionIdEditingCtrlr,
                      isRemarkField: false,
                      date: idPurchaseCtrl.dateTimeEditingCtrlr,
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
                            idPurchaseCtrl.dateTimeEditingCtrlr.text =
                                DateFormat('yyyy-MM-dd').format(value);
                          }
                        });
                      },
                      onSearchPressed: () async {
                        idPurchaseCtrl.resetDataAfterSearching();
                        Get.back();
                        await idPurchaseCtrl
                            .getIdPurchaseList(
                          page: 1,
                          transaction_id:
                              "${idPurchaseCtrl.transactionIdEditingCtrlr.text}",
                          date: idPurchaseCtrl.dateTimeEditingCtrlr.text,
                        )
                            .then((value) {
                          idPurchaseCtrl.dateTimeEditingCtrlr.clear();
                          idPurchaseCtrl.transactionIdEditingCtrlr.clear();
                        });
                      });
                },
                hintext: storedLanguage['Search title'] ?? 'Search title',
                controller: idPurchaseCtrl.titleEditingCtrlr,
                onChanged: (v) {
                  idPurchaseCtrl.querytitle(v);
                },
              ),
              VSpace(24.h),
              idPurchaseCtrl.isLoading
                  ? Helpers.appLoader()
                  : Expanded(
                      child: RefreshIndicator(
                      color: AppColors.mainColor,
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: () async {
                        idPurchaseCtrl.resetDataAfterSearching(
                            isFromOnRefreshIndicator: true);
                        await idPurchaseCtrl.getIdPurchaseList(
                            page: 1, transaction_id: '', date: '');
                      },
                      child: ListView.builder(
                          itemCount: idPurchaseCtrl.isSearching
                              ? idPurchaseCtrl.searchedPurchaseList.isEmpty
                                  ? 1
                                  : idPurchaseCtrl.searchedPurchaseList.length
                              : idPurchaseCtrl.idPurchaseList.isEmpty
                                  ? 1
                                  : idPurchaseCtrl.idPurchaseList.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: idPurchaseCtrl.scrollController,
                          itemBuilder: (context, i) {
                            if (idPurchaseCtrl.isSearching == false &&
                                idPurchaseCtrl.idPurchaseList.isEmpty) {
                              return Helpers.notFound();
                            } else if (idPurchaseCtrl.isSearching == true &&
                                idPurchaseCtrl.searchedPurchaseList.isEmpty) {
                              return Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: Dimensions.screenHeight * .25),
                                  height: 180.h,
                                  width: 180.h,
                                  child: Image.asset(
                                    "$rootImageDir/not_found.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                            var data = idPurchaseCtrl.isSearching
                                ? idPurchaseCtrl.searchedPurchaseList[i]
                                : idPurchaseCtrl.idPurchaseList[i];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24.r),
                                onTap: () {
                                  showDialog<void>(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 60.h, horizontal: 30.w),
                                        child: Material(
                                          // Wrap with Material
                                          elevation: 0,
                                          type: MaterialType.transparency,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    width: context.mQuery.width,
                                                    decoration: BoxDecoration(
                                                        color: AppThemes
                                                            .getDarkBgColor(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    32.r)),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 72.h,
                                                          width:
                                                              double.maxFinite,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .mainColor,
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            32.r)),
                                                          ),
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Positioned(
                                                                top: -120.h,
                                                                right: -90.w,
                                                                child:
                                                                    Container(
                                                                  height: 170.h,
                                                                  width: 170.w,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xff4BABFE),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: Dimensions
                                                                    .kDefaultPadding,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        storedLanguage['CREDENTIALS'] ??
                                                                            "CREDENTIALS",
                                                                        style: context
                                                                            .t
                                                                            .bodyMedium
                                                                            ?.copyWith(color: AppColors.whiteColor)),
                                                                    InkResponse(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(7.h),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              111,
                                                                              185,
                                                                              249),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              18.h,
                                                                          color:
                                                                              AppColors.whiteColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        VSpace(24.h),
                                                        Padding(
                                                          padding: Dimensions
                                                              .kDefaultPadding,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (idPurchaseCtrl
                                                                  .isSearching)
                                                                ...idPurchaseCtrl
                                                                    .searchedDynamicFormList[
                                                                        i]
                                                                    .form
                                                                    .map(
                                                                      (e) =>
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              e.fieldName,
                                                                              style: context.t.displayMedium),
                                                                          VSpace(
                                                                              8.h),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  height: 43.h,
                                                                                  alignment: Alignment.centerLeft,
                                                                                  padding: EdgeInsets.only(left: 16.h),
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppThemes.getFillColor(),
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(32.r),
                                                                                      bottomLeft: Radius.circular(32.r),
                                                                                    ),
                                                                                  ),
                                                                                  child: Text(
                                                                                    e.fieldValue,
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: context.t.bodySmall?.copyWith(color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                                                  Clipboard.setData(new ClipboardData(text: "${e.fieldValue}"));
                                                                                  Helpers.showSnackBar(msg: "Copied Successfully", bgColor: AppColors.greenColor);
                                                                                },
                                                                                child: Container(
                                                                                  height: 44.h,
                                                                                  width: 41.w,
                                                                                  padding: EdgeInsets.all(12.h),
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColors.mainColor,
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topRight: Radius.circular(32.r),
                                                                                      bottomRight: Radius.circular(32.r),
                                                                                    ),
                                                                                  ),
                                                                                  child: Image.asset("$rootImageDir/copy.png"),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          VSpace(
                                                                              24.h),
                                                                        ],
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                              if (!idPurchaseCtrl
                                                                  .isSearching)
                                                                ...idPurchaseCtrl
                                                                    .dynamicFormList[
                                                                        i]
                                                                    .form
                                                                    .map(
                                                                      (e) =>
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              e.fieldName,
                                                                              style: context.t.displayMedium),
                                                                          VSpace(
                                                                              8.h),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  height: 43.h,
                                                                                  alignment: Alignment.centerLeft,
                                                                                  padding: EdgeInsets.only(left: 16.h),
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppThemes.getFillColor(),
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(32.r),
                                                                                      bottomLeft: Radius.circular(32.r),
                                                                                    ),
                                                                                  ),
                                                                                  child: Text(
                                                                                    e.fieldValue,
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: context.t.bodySmall?.copyWith(color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                                                  Clipboard.setData(new ClipboardData(text: "${e.fieldValue}"));
                                                                                  Helpers.showSnackBar(msg: "Copied Successfully", bgColor: AppColors.greenColor);
                                                                                },
                                                                                child: Container(
                                                                                  height: 44.h,
                                                                                  width: 41.w,
                                                                                  padding: EdgeInsets.all(12.h),
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColors.mainColor,
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topRight: Radius.circular(32.r),
                                                                                      bottomRight: Radius.circular(32.r),
                                                                                    ),
                                                                                  ),
                                                                                  child: Image.asset("$rootImageDir/copy.png"),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          VSpace(
                                                                              24.h),
                                                                        ],
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                              Text(
                                                                  storedLanguage[
                                                                          'Transaction'] ??
                                                                      'Transaction',
                                                                  style: context
                                                                      .t
                                                                      .displayMedium),
                                                              VSpace(8.h),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          43.h,
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              16.h),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppThemes
                                                                            .getFillColor(),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(32.r),
                                                                          bottomLeft:
                                                                              Radius.circular(32.r),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        data.trx,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: context
                                                                            .t
                                                                            .bodySmall
                                                                            ?.copyWith(color: Get.isDarkMode ? AppColors.whiteColor : AppColors.black50),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .removeCurrentSnackBar();
                                                                      Clipboard.setData(
                                                                          new ClipboardData(
                                                                              text: "${data.trx}"));
                                                                      Helpers.showSnackBar(
                                                                          title:
                                                                              "Success",
                                                                          msg:
                                                                              "Copied Successfully",
                                                                          bgColor:
                                                                              AppColors.greenColor);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          44.h,
                                                                      width:
                                                                          41.w,
                                                                      padding: EdgeInsets
                                                                          .all(12
                                                                              .h),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppColors
                                                                            .mainColor,
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topRight:
                                                                              Radius.circular(32.r),
                                                                          bottomRight:
                                                                              Radius.circular(32.r),
                                                                        ),
                                                                      ),
                                                                      child: Image
                                                                          .asset(
                                                                              "$rootImageDir/copy.png"),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              VSpace(40.h),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Ink(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: AppThemes.getDarkCardColor(),
                                    borderRadius: BorderRadius.circular(24.r),
                                    border: Border.all(
                                        color: AppColors.mainColor, width: .2),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(data.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.bodyMedium),
                                            Text(data.category,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.bodySmall
                                                    ?.copyWith(
                                                        color:
                                                            AppColors.mainColor,
                                                        fontSize: 12.sp)),
                                            VSpace(5.h),
                                            Text(
                                                DateFormat(
                                                        'dd MMM yyyy hh:mm a')
                                                    .format(DateTime.parse(
                                                        data.dateTime)),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.bodySmall),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              data.symbol +
                                                  data.amount.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.t.bodyMedium),
                                          VSpace(10.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 3.h),
                                            decoration: BoxDecoration(
                                                color: Get.isDarkMode
                                                    ? AppColors.darkBgColor
                                                    : AppColors.bgColor,
                                                borderRadius:
                                                    BorderRadius.circular(6.r)),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.h,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )),
              if (idPurchaseCtrl.isLoadMore == true)
                Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                    child: Helpers.appLoader()),
              VSpace(20.h),
            ],
          ),
        ),
      );
    });
  }
}
