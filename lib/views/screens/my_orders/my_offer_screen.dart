// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gamers_arena/config/dimensions.dart';
// import 'package:gamers_arena/themes/themes.dart';
// import 'package:gamers_arena/views/widgets/custom_textfield.dart';
// import 'package:gamers_arena/views/widgets/spacing.dart';
// import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../../config/app_colors.dart';
// import '../../../controllers/my_offer_controller.dart';
// import '../../../utils/app_constants.dart';
// import '../../../utils/services/helpers.dart';
// import '../../widgets/custom_appbar.dart';
// import '../../widgets/search_dialog.dart';
// import 'my_offer_details_screen.dart';
//
// class MyOfferScreen extends StatelessWidget {
//   const MyOfferScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<MyOfferController>(builder: (myOfferCtrl) {
//       return GestureDetector(
//         onTap: () => Helpers.hideKeyboard(),
//         child: Scaffold(
//           backgroundColor:
//               Get.isDarkMode ? AppColors.darkBgColor : AppColors.bgColor,
//           appBar: const CustomAppBar(
//             title: "My Offer",
//           ),
//           body: Padding(
//             padding: Dimensions.kDefaultPadding,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 VSpace(20.h),
//                 CustomTextField(
//                   height: 45.h,
//                   isPrefixIcon: true,
//                   isSuffixBgColor: true,
//                   isSuffixIcon: true,
//                   prefixIcon: 'search',
//                   suffixIcon: 'filter',
//                   onSuffixPressed: () {
//                     searchDialog(
//                         context: context,
//                         isTransactionField: false,
//                         isRemarkField: false,
//                         date: myOfferCtrl.dateTimeEditingCtrlr,
//                         onDatePressed: () async {
//                           /// SHOW DATE PICKER
//                           await showDatePicker(
//                                   context: context,
//                                   builder: (context, child) {
//                                     return Theme(
//                                         data: Theme.of(context).copyWith(
//                                           colorScheme: ColorScheme.dark(
//                                             background: AppColors.bgColor,
//                                             onPrimary: AppColors.whiteColor,
//                                           ),
//                                           textButtonTheme: TextButtonThemeData(
//                                             style: TextButton.styleFrom(
//                                               foregroundColor: AppColors
//                                                   .mainColor, // button text color
//                                             ),
//                                           ),
//                                         ),
//                                         child: child!);
//                                   },
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2000),
//                                   lastDate: DateTime(2025))
//                               .then((value) {
//                             if (value != null) {
//                               print(value.toUtc());
//                               myOfferCtrl.dateTimeEditingCtrlr.text =
//                                   DateFormat('yyyy-MM-dd').format(value);
//                             }
//                           });
//                         },
//                         onSearchPressed: () async {
//                           myOfferCtrl.resetDataAfterSearching();
//                           Get.back();
//                           await myOfferCtrl
//                               .getMyOfferList(
//                           )
//                               .then((value) {
//                             myOfferCtrl.dateTimeEditingCtrlr.clear();
//                           });
//                         });
//                   },
//                   hintext: 'Search title',
//                   controller: myOfferCtrl.titleEditingCtrlr,
//                   onChanged: (v) {
//                     myOfferCtrl.querytitle(v);
//                   },
//                 ),
//                 VSpace(24.h),
//                 myOfferCtrl.isLoading
//                     ? Helpers.appLoader()
//                     : Expanded(
//                         child: RefreshIndicator(
//                         color: AppColors.mainColor,
//                         triggerMode: RefreshIndicatorTriggerMode.onEdge,
//                         onRefresh: () async {
//                           myOfferCtrl.resetDataAfterSearching(
//                               isFromOnRefreshIndicator: true);
//                           await myOfferCtrl.getMyOfferList(page: 1, date: '');
//                         },
//                         child: ListView.builder(
//                             itemCount: myOfferCtrl.isSearching
//                                 ? myOfferCtrl.searchedMyOfferList.isEmpty
//                                     ? 1
//                                     : myOfferCtrl.searchedMyOfferList.length
//                                 : myOfferCtrl.myOfferList.isEmpty
//                                     ? 1
//                                     : myOfferCtrl.myOfferList.length,
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             controller: myOfferCtrl.scrollController,
//                             itemBuilder: (context, i) {
//                               if (myOfferCtrl.isSearching == false &&
//                                   myOfferCtrl.myOfferList.isEmpty) {
//                                 return Helpers.notFound();
//                               } else if (myOfferCtrl.isSearching == true &&
//                                   myOfferCtrl.searchedMyOfferList.isEmpty) {
//                                 return Helpers.notFound();
//                               }
//                               var data = myOfferCtrl.isSearching
//                                   ? myOfferCtrl.searchedMyOfferList[i]
//                                   : myOfferCtrl.myOfferList[i];
//                               return Padding(
//                                 padding: EdgeInsets.only(bottom: 12.h),
//                                 child: InkWell(
//                                   borderRadius: BorderRadius.circular(24.r),
//                                   onTap: () {
//                                     myOfferCtrl.getMyOfferDetails(
//                                         id: data.id.toString());
//                                     Get.to(() => MyOfferDetailsScreen());
//                                   },
//                                   child: Ink(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 20.w, vertical: 12.h),
//                                     decoration: BoxDecoration(
//                                       color: AppThemes.getDarkCardColor(),
//                                       borderRadius: BorderRadius.circular(24.r),
//                                       border: Border.all(
//                                           color: AppColors.mainColor,
//                                           width: .2),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 40.h,
//                                           height: 40.h,
//                                           padding: EdgeInsets.all(10.h),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(12.r),
//                                             color: checkStatusBorderColor(
//                                                     data.status)
//                                                 .withOpacity(.1),
//                                             border: Border.all(
//                                                 color: checkStatusBorderColor(
//                                                     data.status),
//                                                 width: .2),
//                                           ),
//                                           child: Image.asset(
//                                             checkStatusIcon(data.status),
//                                             color:
//                                                 checkStatusColor(data.status),
//                                           ),
//                                         ),
//                                         HSpace(12.w),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Flexible(
//                                                     child: Text(data.title,
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: context
//                                                             .t.bodyMedium),
//                                                   ),
//                                                   if (data.sellingStatus ==
//                                                       "sold")
//                                                     Container(
//                                                       margin: EdgeInsets.only(
//                                                           left: 7.w),
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               vertical: 2.h,
//                                                               horizontal: 5.w),
//                                                       decoration: BoxDecoration(
//                                                         color:
//                                                             AppColors.mainColor,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(6.r),
//                                                       ),
//                                                       child: Text("Sold",
//                                                           style: context
//                                                               .t.bodySmall
//                                                               ?.copyWith(
//                                                                   fontSize:
//                                                                       12.sp,
//                                                                   color: AppColors
//                                                                       .whiteColor)),
//                                                     ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Expanded(
//                                                     child: Text(data.category,
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: context
//                                                             .t.bodySmall
//                                                             ?.copyWith(
//                                                                 color: AppColors
//                                                                     .mainColor,
//                                                                 fontSize:
//                                                                     12.sp)),
//                                                   ),
//                                                   Expanded(
//                                                     child: Container(
//                                                       alignment:
//                                                           Alignment.centerRight,
//                                                       child: Text(
//                                                           data.symbol +
//                                                               data.price
//                                                                   .toString(),
//                                                           maxLines: 1,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style: context
//                                                               .t.bodyMedium),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               VSpace(5.h),
//                                               Text(
//                                                   DateFormat(
//                                                           'dd MMM yyyy hh:mm a')
//                                                       .format(DateTime.parse(
//                                                           data.dateTime)),
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: context.t.bodySmall),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                       )),
//                 if (myOfferCtrl.isLoadMore == true)
//                   Padding(
//                       padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
//                       child: Helpers.appLoader()),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   checkStatusIcon(dynamic status) {
//     if (status == "Accept") {
//       return "$rootImageDir/approved.png";
//     } else if (status == "Pending") {
//       return "$rootImageDir/pending.png";
//     } else if (status == "Rejected" || status == "Reject") {
//       return "$rootImageDir/rejected.png";
//     } else {
//       return "$rootImageDir/resubmit.png";
//     }
//   }
//
//   checkStatusColor(dynamic status) {
//     if (status == "Accept") {
//       return AppColors.greenColor;
//     } else if (status == "Pending") {
//       return AppColors.pendingColor;
//     } else if (status == "Rejected" || status == "Reject") {
//       return AppColors.redColor;
//     } else {
//       return AppColors.mainColor;
//     }
//   }
//
//   checkStatusBorderColor(dynamic status) {
//     if (status == "Accept") {
//       return AppColors.greenColor;
//     } else if (status == "Pending") {
//       return AppColors.pendingColor;
//     } else if (status == "Rejected" || status == "Reject") {
//       return AppColors.redColor;
//     } else {
//       return AppColors.mainColor;
//     }
//   }
// }
