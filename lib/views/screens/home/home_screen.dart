import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/bindings/controller_index.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:gamers_arena/views/screens/my_orders/giftCard_order_screen.dart';
import 'package:gamers_arena/views/screens/payment_and_addFund/transaction_screen.dart';
import 'package:gamers_arena/views/screens/profile/profile_setting_screen.dart';
import 'package:gamers_arena/views/widgets/app_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';

import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import 'charging_account.dart';

var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isCollapsed = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.delete<WithdrawController>();
    Get.delete<AddFundController>();
    Get.put(ProfileController());
    Get.put(TransactionController());

    return GetBuilder<AppController>(builder: (_) {
      return GetBuilder<TransactionController>(builder: (transactionCtrl) {
        return GetBuilder<ProfileController>(builder: (profileCtrl) {
          return GetBuilder<DashboardController>(builder: (dashboardCtrl) {
            return Scaffold(
              key: scaffoldKey,
              appBar: buildAppbar(profileCtrl),
              drawer: buildDrawer(t, storedLanguage, context),
              body: RefreshIndicator(
                color: AppColors.mainColor,
                onRefresh: () async {},
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "أهلا," +
                                    (profileCtrl.isLoading
                                        ? ''
                                        : profileCtrl.userName),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.bodyLarge?.copyWith(
                                  fontSize: 18.sp,
                                )),
                            VSpace(15.h),
                            dashboardCtrl.isLoading || dashboardCtrl.dataSlider.isEmpty
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    width: double.maxFinite,
                                    height: 150.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/logo.png',
                                          height: 150.h,
                                        ),
                                        Text(
                                          'مرحبا بك في Pro Pay',
                                          style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 20.sp),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.imageBgColor,
                                      borderRadius: BorderRadius.circular(24.r),
                                      border: Border.all(
                                          color: AppColors.imageBgColor,
                                          width: .2),
                                    ),
                                  )
                                : CarouselSlider.builder(
                                    itemCount: dashboardCtrl.dataSlider.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.h),
                                        width: double.maxFinite,
                                        height: 150.h,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                dashboardCtrl.dataSlider[index]
                                                        .photo ??
                                                    ''),
                                            fit: BoxFit.fill,
                                          ),
                                          color: AppColors.imageBgColor,
                                          borderRadius:
                                              BorderRadius.circular(24.r),
                                          border: Border.all(
                                              color: AppColors.imageBgColor,
                                              width: .2),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 150.h,
                                      aspectRatio: 16 / 9,
                                      autoPlay: dashboardCtrl.dataSlider.length > 1 ?  true : false,
                                      viewportFraction: 1,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      VSpace(20.h),
                      Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 15.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.withdrawColor
                                          .withOpacity(.3),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                          color: AppColors.mainColor,
                                          width: .2),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 42.h,
                                              width: 42.h,
                                              padding: EdgeInsets.all(11.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.withdrawColor,
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                              ),
                                              child: Image.asset(
                                                '$rootImageDir/wallet.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            HSpace(10.w),
                                            Text(
                                                '${dashboardCtrl.baseCurrencySymbol}${profileCtrl.balance}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodyMedium?.copyWith(
                                                  fontSize: 16.sp,
                                                )),
                                          ],
                                        ),
                                        VSpace(16.h),
                                        Text('رصيد المحفظة',
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: t.bodySmall?.copyWith(
                                              fontSize: 12.sp,
                                              color:
                                                  AppThemes.getBlack50Color(),
                                              fontWeight: FontWeight.w700,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                HSpace(10.w),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => GiftCardOrderScreen(
                                        FilterName: 'Authority',
                                      ));
                                    },
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 15.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.topupColor
                                            .withOpacity(.3),
                                        borderRadius:
                                        BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: AppColors.mainColor,
                                            width: .2),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 42.h,
                                              width: 42.h,
                                              padding: EdgeInsets.all(9.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.topupColor,
                                                borderRadius:
                                                BorderRadius.circular(16.r),
                                              ),
                                              child: Icon(
                                                Icons.call,
                                              )),
                                          VSpace(16.h),
                                          Text(
                                            'رصيد',
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: t.bodySmall?.copyWith(
                                              fontSize: 12.sp,
                                              color:
                                              AppThemes.getBlack50Color(),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                HSpace(10.w),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => GiftCardOrderScreen(
                                        FilterName: 'Games',
                                      ));
                                    },
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 15.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.redColor
                                            .withOpacity(.3),
                                        borderRadius:
                                        BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: AppColors.redColor,
                                            width: .2),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 42.h,
                                              width: 42.h,
                                              padding: EdgeInsets.all(9.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.redColor,
                                                borderRadius:
                                                BorderRadius.circular(16.r),
                                              ),
                                              child: Icon(
                                                Icons.games_sharp,
                                              )),
                                          VSpace(16.h),
                                          Text(
                                            'شحن التطبيقات',
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: t.bodySmall?.copyWith(
                                              fontSize: 10.sp,
                                              color:
                                              AppThemes.getBlack50Color(),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            VSpace(25.h),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => GiftCardOrderScreen(
                                            FilterName: 'services',
                                          ));
                                    },
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 19.h, bottom: 19.h, right: 15.w),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.pendingColor.withOpacity(.3),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: AppColors.pendingColor,
                                            width: .2),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 43.h,
                                            width: 43.h,
                                            padding: EdgeInsets.all(8.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.pendingColor,
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                            ),
                                            child: Icon(
                                              Icons.category,
                                            ),
                                          ),
                                          HSpace(20.h),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'السورية للمدفوعات الالكترونية',
                                                  maxLines: 2,
                                                  overflow: TextOverflow.fade,
                                                  style: t.bodyMedium?.copyWith(
                                                    fontSize: 14.sp,
                                                    color: AppThemes
                                                        .getBlack50Color(),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                HSpace(10.w),
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => GiftCardOrderScreen(
                                        FilterName: 'ADSL',
                                      ));
                                    },
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 19.h, bottom: 19.h, right: 15.w),
                                      decoration: BoxDecoration(
                                        color:
                                        AppColors.voucherColor.withOpacity(.3),
                                        borderRadius:
                                        BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: AppColors.voucherColor,
                                            width: .2),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 43.h,
                                            width: 43.h,
                                            padding: EdgeInsets.all(8.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.voucherColor,
                                              borderRadius:
                                              BorderRadius.circular(16.r),
                                            ),
                                            child: Icon(
                                              Icons.router_outlined,
                                            ),
                                          ),
                                          HSpace(20.h),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ADSL',
                                                  maxLines: 2,
                                                  overflow: TextOverflow.fade,
                                                  style: t.bodyMedium?.copyWith(
                                                    fontSize: 18.sp,
                                                    color: AppThemes
                                                        .getBlack50Color(),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                            VSpace(25.h),
                            Divider(),
                            VSpace(25.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('المعاملات',
                                    style: t.bodyLarge?.copyWith(
                                      fontSize: 18.sp,
                                    )),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => TransactionScreen(
                                        isFromHomePage: true));
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Text(
                                        storedLanguage['See All'] ??
                                            'مشاهدة الكل',
                                        style: t.displayMedium?.copyWith(
                                          fontSize: 16.sp,
                                          color: AppThemes.getBlack50Color(),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(17.h),
                            transactionCtrl.isLoading
                                ? Helpers.appLoader()
                                : transactionCtrl.transactionList.isEmpty
                                    ? Center(
                                        child: Container(
                                          height: 140.h,
                                          width: 140.h,
                                          child: Image.asset(
                                            Get.isDarkMode
                                                ? "$rootImageDir/not_found_dark.png"
                                                : "$rootImageDir/not_found.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: transactionCtrl
                                                    .transactionList.length >
                                                10
                                            ? 10
                                            : transactionCtrl
                                                .transactionList.length,
                                        itemBuilder: (context, i) {
                                          var clampedIndex = i.clamp(
                                              0,
                                              transactionCtrl
                                                      .transactionList.length -
                                                  1);
                                          var data = transactionCtrl
                                              .transactionList[clampedIndex];

                                          return Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 14.h),
                                            margin:
                                                EdgeInsets.only(bottom: 10.h),
                                            decoration: BoxDecoration(
                                              color: AppThemes.getFillColor(),
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              border: Border.all(
                                                  color: AppColors.mainColor,
                                                  width: 0.2),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40.h,
                                                  height: 40.h,
                                                  padding: EdgeInsets.all(8.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    color: data.color ==
                                                            'success'
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
                                                      color: data.color ==
                                                              'success'
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        data.arabicName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.bodyMedium
                                                            ?.copyWith(
                                                                fontSize:
                                                                    14.sp),
                                                      ),
                                                      SizedBox(height: 3.h),
                                                      Text(
                                                        DateFormat(
                                                                'dd MMM yyyy hh:mm a')
                                                            .format(DateTime
                                                                .parse(data
                                                                    .createdDate)),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.bodySmall
                                                            ?.copyWith(
                                                          fontSize: 12.sp,
                                                          color: AppThemes
                                                              .getBlack50Color(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Flexible(
                                                  flex: 4,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      "${data.result}", // Adjust based on your data field
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: t.bodyMedium
                                                          ?.copyWith(
                                                        fontSize: 14.sp,
                                                        color:
                                                            AppColors.redColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
      });
    });
  }

  CustomAppBar buildAppbar(ProfileController profileCtrl) {
    return CustomAppBar(
      toolberHeight: 100.h,
      prefferSized: 100.h,
      isTitleMarginTop: true,
      leading: IconButton(
          padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: Image.asset(
            "$rootImageDir/menu.png",
            height: 26.h,
            width: 26.h,
            color: AppThemes.getIconBlackColor(),
            fit: BoxFit.fitHeight,
          )),
      title: "",
      actions: [
        InkResponse(
          onTap: () {
            Get.to(() => ProfileSettingScreen(isFromHomePage: true));
          },
          child: Container(
            height: 38.h,
            width: 38.h,
            margin: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
            decoration: BoxDecoration(
              color: AppColors.imageBgColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.mainColor, width: .2),
              image: profileCtrl.isLoading || profileCtrl.userPhoto == ''
                  ? DecorationImage(
                      image: AssetImage(
                        "$rootImageDir/avatar.webp",
                      ),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: CachedNetworkImageProvider(profileCtrl.userPhoto),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        HSpace(10.w),
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.put(PushNotificationController()).isNotiSeen();
                },
                padding: EdgeInsets.only(top: Platform.isIOS ? 40.h : 20.h),
                icon: Image.asset(
                  "$rootImageDir/notification.png",
                  height: 28.h,
                  width: 28.h,
                  color: AppThemes.getIconBlackColor(),
                  fit: BoxFit.fitHeight,
                )),
            Obx(() => Positioned(
                top: Platform.isIOS ? 39.h : 23.h,
                right: 17.w,
                child: CircleAvatar(
                  radius: 6.r,
                  backgroundColor:
                      Get.put(PushNotificationController()).isSeen.value ==
                              false
                          ? AppColors.redColor
                          : Colors.transparent,
                ))),
          ],
        ),
        HSpace(20.w),
      ],
    );
  }
}
