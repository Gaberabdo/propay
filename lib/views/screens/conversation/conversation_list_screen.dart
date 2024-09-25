import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/config/dimensions.dart';
import 'package:gamers_arena/controllers/conversation_controller.dart';
import 'package:gamers_arena/views/screens/conversation/inbox_screen.dart';
import 'package:gamers_arena/views/widgets/custom_appbar.dart';
import 'package:gamers_arena/views/widgets/spacing.dart';
import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import '../../../notification_service/notification_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ConversationController>(builder: (convCtrl) {
      return WillPopScope(
        onWillPop: () {
          Get.put(PushNotificationController()).getPushNotificationConfig();
          return Future.value(true);
        },
        child: GestureDetector(
          onTap: () => Helpers.hideKeyboard(),
          child: Scaffold(
            appBar: buildAppbar(storedLanguage),
            body: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(20.h),
                  CustomTextField(
                    height: 45.h,
                    isPrefixIcon: true,
                    isSuffixIcon: true,
                    isSuffixBgColor: true,
                    prefixIcon: 'search',
                    suffixIcon: 'filter',
                    onChanged: (v) {
                      convCtrl.querytitle(v);
                    },
                    onSuffixPressed: () {
                      appDialog(
                          context: context,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Filter Now",
                                  style: Styles.bodyMedium.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor)),
                              InkResponse(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7.h),
                                  decoration: BoxDecoration(
                                    color: AppThemes.getFillColor(),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 14.h,
                                    color: AppThemes.getIconBlackColor(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () async {
                                  /// SHOW DATE PICKER
                                  await showDatePicker(
                                          context: context,
                                          builder: (context, child) {
                                            return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.dark(
                                                    background:
                                                        AppColors.bgColor,
                                                    onPrimary:
                                                        AppColors.whiteColor,
                                                  ),
                                                  textButtonTheme:
                                                      TextButtonThemeData(
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
                                      convCtrl.dateTimeEditingCtrl.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value);
                                    }
                                  });
                                },
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: CustomTextField(
                                    hintext: "Choose Date",
                                    controller: convCtrl.dateTimeEditingCtrl,
                                    contentPadding: EdgeInsets.only(left: 20.w),
                                  ),
                                ),
                              ),
                              VSpace(28.h),
                              GetBuilder<ConversationController>(
                                  builder: (convCtrl) {
                                return Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: AppThemes.getFillColor(),
                                      borderRadius: Dimensions.kBorderRadius,
                                      border: Border.all(
                                          color: AppColors.mainColor,
                                          width: .2),
                                    ),
                                    child: AppCustomDropDown(
                                      height: 46.h,
                                      width: double.infinity,
                                      items: convCtrl.offerCategoryList
                                          .map((OfferCategory e) => e.name)
                                          .toList(),
                                      selectedValue: convCtrl.selectedVal,
                                      onChanged: (value) async {
                                        convCtrl.selectedVal = value;
                                        var selectedVal = await convCtrl
                                            .offerCategoryList
                                            .firstWhere((e) => e.name == value);
                                        convCtrl.sortBy = selectedVal.value;
                                        convCtrl.update();
                                      },
                                      hint: "Sort By",
                                      selectedStyle: context.t.displayMedium,
                                    ));
                              }),
                              VSpace(24.h),
                              AppButton(
                                text: "Search Now",
                                onTap: () async {
                                  convCtrl.resetDataAfterSearching();
                                  Get.back();
                                  await convCtrl
                                      .getConversationList(
                                    page: 1,
                                    dateTime: convCtrl.dateTimeEditingCtrl.text,
                                    sortBy: convCtrl.sortBy,
                                  )
                                      .then((value) {
                                    convCtrl.dateTimeEditingCtrl.clear();
                                    convCtrl.selectedVal = null;
                                    convCtrl.sortBy = "";
                                  });
                                },
                              ),
                            ],
                          ));
                    },
                    hintext: storedLanguage['Search here'] ?? 'Search here',
                    controller: convCtrl.searchEditingCtrl,
                  ),
                  VSpace(25.h),
                  convCtrl.isLoading
                      ? Helpers.appLoader()
                      : Expanded(
                          child: RefreshIndicator(
                            color: AppColors.mainColor,
                            triggerMode: RefreshIndicatorTriggerMode.onEdge,
                            onRefresh: () async {
                              convCtrl.resetDataAfterSearching(
                                  isFromOnRefreshIndicator: true);
                              await convCtrl.getConversationList(
                                  page: 1, dateTime: "", sortBy: "");
                            },
                            child: ListView.builder(
                                controller: convCtrl.scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: convCtrl.isSearching
                                    ? convCtrl.searchedConversationList.isEmpty
                                        ? 1
                                        : convCtrl
                                            .searchedConversationList.length
                                    : convCtrl.offerList.isEmpty
                                        ? 1
                                        : convCtrl.offerList.length,
                                itemBuilder: (context, i) {
                                  if (convCtrl.isSearching == false &&
                                      convCtrl.offerList.isEmpty) {
                                    return Helpers.notFound();
                                  } else if (convCtrl.isSearching == true &&
                                      convCtrl
                                          .searchedConversationList.isEmpty) {
                                    return Helpers.notFound();
                                  }
                                  var data = convCtrl.isSearching
                                      ? convCtrl.searchedConversationList[i]
                                      : convCtrl.offerList[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 36.h),
                                    child: InkWell(
                                      onTap: () {
                                        if (data.status == 0) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "The offer is pending. Click on the three-dot menu for more options.");
                                        } else if (data.status == 2) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "The offer is rejected. Click on the three-dot menu for more options.");
                                        } else if (data.status == 3) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "The offer is Resubmission. Click on the three-dot menu for more options.");
                                        } else {
                                          convCtrl.uuid = data.uuid.toString();
                                          convCtrl.getConversation(
                                              uuid: data.uuid);
                                          Get.to(() => InboxScreen(
                                                uuid: data.uuid.toString(),
                                                sellPostId:
                                                    data.sellPostId.toString(),
                                                offerId: data.id.toString(),
                                                name: data.user!.firstname +
                                                    " " +
                                                    data.user!.lastname,
                                              ));
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 55.h,
                                            width: 55.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.mainColor),
                                                shape: BoxShape.circle,
                                                color: AppColors.imageBgColor,
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    data.user!.imgPath
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Container(
                                                  height: 12.h,
                                                  width: 12.h,
                                                  margin: EdgeInsets.only(
                                                      bottom: 3.h, right: 1.w),
                                                  decoration: BoxDecoration(
                                                    color: data.user!
                                                                .lastSeen ==
                                                            false
                                                        ? AppColors.greyColor
                                                        : AppColors.greenColor,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          AppColors.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          HSpace(16.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Text(
                                                          data.sellPost!.title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: context
                                                              .t.bodyMedium),
                                                    ),
                                                    Flexible(
                                                      flex: 2,
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                            "\$${data.amount}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: context
                                                                .t.bodyMedium
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                VSpace(5.h),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 9,
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                                data.user!
                                                                        .firstname +
                                                                    " " +
                                                                    data.user!
                                                                        .lastname,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: context
                                                                    .t.bodySmall
                                                                    ?.copyWith(
                                                                        color: Get.isDarkMode
                                                                            ? AppColors.black30
                                                                            : AppColors.black50)),
                                                          ),
                                                          HSpace(5.w),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4.w,
                                                                    vertical:
                                                                        2.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: data.status ==
                                                                      0
                                                                  ? AppColors
                                                                      .pendingColor
                                                                  : data.status ==
                                                                          1
                                                                      ? AppColors
                                                                          .greenColor
                                                                      : data.status ==
                                                                              2
                                                                          ? AppColors
                                                                              .redColor
                                                                          : data.status == 3
                                                                              ? AppColors.topupColor
                                                                              : Colors.transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6.r),
                                                            ),
                                                            child: Text(
                                                              data.status == 0
                                                                  ? "Pending"
                                                                  : data.status ==
                                                                          1
                                                                      ? "Accepted"
                                                                      : data.status ==
                                                                              2
                                                                          ? "Rejected"
                                                                          : data.status == 3
                                                                              ? "Resubmission"
                                                                              : "",
                                                              style: context.t.bodySmall?.copyWith(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: data.status == 0 ||
                                                                          data.status ==
                                                                              1 ||
                                                                          data.status ==
                                                                              2 ||
                                                                          data.status ==
                                                                              3
                                                                      ? AppColors
                                                                          .whiteColor
                                                                      : Colors
                                                                          .transparent),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 4,
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                            timeago.format(
                                                                DateTime.parse(data
                                                                    .createdAt)),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: context.t.bodySmall?.copyWith(
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .black30
                                                                    : AppColors
                                                                        .black50)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                VSpace(3.h),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          data.description
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: context
                                                              .t.displayMedium),
                                                    ),
                                                    if (data.status == 0 ||
                                                        data.status == 2 ||
                                                        data.status == 3)
                                                      SizedBox(
                                                        height: 30.h,
                                                        width: 30.w,
                                                        child: PopupMenuButton<
                                                            String>(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onSelected: (String
                                                              selectedValue) {
                                                            if (selectedValue ==
                                                                "Accept") {
                                                              appDialog(
                                                                  context:
                                                                      context,
                                                                  title: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          "Accept Offer",
                                                                          style: context
                                                                              .t
                                                                              .displayMedium),
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
                                                                              BoxDecoration(
                                                                            color:
                                                                                AppThemes.getFillColor(),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.close,
                                                                            size:
                                                                                14.h,
                                                                            color:
                                                                                AppThemes.getIconBlackColor(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          storedLanguage['Say Something'] ??
                                                                              "Say Something",
                                                                          style: context
                                                                              .t
                                                                              .displayMedium),
                                                                      VSpace(
                                                                          10.h),
                                                                      TextFormField(
                                                                        controller:
                                                                            convCtrl.offerAcceptCtrl,
                                                                        maxLines:
                                                                            7,
                                                                        minLines:
                                                                            5,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          contentPadding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 8,
                                                                              horizontal: 16),
                                                                          filled:
                                                                              true,
                                                                          hintStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.textFieldHintColor,
                                                                          ),
                                                                          fillColor:
                                                                              AppThemes.getFillColor(), // Background color
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25.r),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: AppColors.mainColor,
                                                                              width: .2,
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25.r),
                                                                            borderSide:
                                                                                BorderSide(color: AppColors.mainColor),
                                                                          ),
                                                                        ),
                                                                        style: context
                                                                            .t
                                                                            .bodyMedium,
                                                                      ),
                                                                      VSpace(
                                                                          28.h),
                                                                      GetBuilder<
                                                                              ConversationController>(
                                                                          builder:
                                                                              (convCtrl) {
                                                                        return AppButton(
                                                                          isLoading: convCtrl.isAccepting
                                                                              ? true
                                                                              : false,
                                                                          text:
                                                                              "Submit",
                                                                          onTap:
                                                                              () async {
                                                                            if (convCtrl.offerAcceptCtrl.text.isEmpty) {
                                                                              Helpers.showSnackBar(msg: "Description field is required");
                                                                            } else {
                                                                              convCtrl.offerAccept(context: context, fields: {
                                                                                "offer_id": data.id.toString(),
                                                                                "description": convCtrl.offerAcceptCtrl.text,
                                                                              });
                                                                            }
                                                                          },
                                                                        );
                                                                      }),
                                                                    ],
                                                                  ));
                                                            } else if (selectedValue ==
                                                                "Reject") {
                                                              convCtrl
                                                                  .offerReject(
                                                                      fields: {
                                                                    "offer_id": data
                                                                        .id
                                                                        .toString(),
                                                                  });
                                                            } else if (selectedValue ==
                                                                "Remove") {
                                                              convCtrl
                                                                  .offerRemove(
                                                                      fields: {
                                                                    "offer_id": data
                                                                        .id
                                                                        .toString(),
                                                                  });
                                                            }
                                                          },
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context) =>
                                                                  <PopupMenuEntry<
                                                                      String>>[
                                                            PopupMenuItem<
                                                                String>(
                                                              value: 'Accept',
                                                              child: Text(
                                                                'Accept',
                                                                style: context.t
                                                                    .displayMedium,
                                                              ),
                                                            ),
                                                            if (data.status !=
                                                                2)
                                                              PopupMenuItem<
                                                                  String>(
                                                                value: 'Reject',
                                                                child: Text(
                                                                  'Reject',
                                                                  style: context
                                                                      .t
                                                                      .displayMedium,
                                                                ),
                                                              ),
                                                            PopupMenuItem<
                                                                String>(
                                                              value: 'Remove',
                                                              child: Text(
                                                                'Remove',
                                                                style: context.t
                                                                    .displayMedium,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                  if (convCtrl.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader()),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  CustomAppBar buildAppbar(storedLanguage) {
    return CustomAppBar(
      leading: IconButton(
          onPressed: () {
            Get.put(PushNotificationController()).getPushNotificationConfig();
            Get.back();
          },
          icon: Container(
            width: 34.h,
            height: 34.h,
            padding: EdgeInsets.all(8.5.h),
            decoration: BoxDecoration(
              color:
                  Get.isDarkMode ? AppColors.darkCardColor : AppColors.black5,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.mainColor, width: .2),
            ),
            child: Image.asset(
              "$rootImageDir/back.png",
              height: 32.h,
              width: 32.h,
              color:
                  Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
              fit: BoxFit.fitHeight,
            ),
          )),
      title: storedLanguage['Offer List'] ?? "Offer List",
    );
  }
}
