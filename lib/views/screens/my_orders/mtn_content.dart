import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/giftCard_order_controller.dart';
import 'package:gamers_arena/routes/page_index.dart';
import 'package:gamers_arena/views/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../config/styles.dart';
import '../../../controllers/voucher_order_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_dialog.dart';
import '../../widgets/spacing.dart';

class MTNContent extends StatelessWidget {
  const MTNContent({
    super.key,
    required this.FilterName,
    required this.catId,
  });
  final String FilterName;
  final String catId;
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<GiftCardOrderController>();
    controller.getMyOfferList(catId);
    print(catId);
    return GetBuilder<GiftCardOrderController>(builder: (giftCardOrderCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Category ${FilterName}",
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            giftCardOrderCtrl.resetDataAfterSearching(
                isFromOnRefreshIndicator: true);
            await giftCardOrderCtrl.getServicesByCategory();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                giftCardOrderCtrl.isLoading
                    ? Helpers.appLoader()
                    : giftCardOrderCtrl.serviceDetails.isEmpty
                        ? Helpers.notFound()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: giftCardOrderCtrl.formKey,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "اكمل العملية",
                                      style: TextStyle(
                                        fontSize: 27.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  if(giftCardOrderCtrl.serviceDetails.first.data != null )
                                  DropdownButtonFormField<String>(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,

                                    validator: (value) {
                                      if (value == null) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    isExpanded:
                                        true, // Ensures the dropdown expands to fit the available space
                                    items: giftCardOrderCtrl
                                        .serviceDetails.first.data!
                                        .map(
                                          (e) => DropdownMenuItem<String>(
                                            value: e.name,
                                            child: Text(
                                              e.name,
                                              overflow: TextOverflow
                                                  .ellipsis, // Prevents text overflow
                                              maxLines:
                                                  1, // Ensures text stays in one line
                                            ),
                                          ),
                                        )
                                        .toList(), // Convert Iterable to List
                                    onChanged: (value) {
                                      giftCardOrderCtrl.changeCValue(value!);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText:
                                          'اختار المحافظة', // Optional: Provide a hint text if needed
                                    ),
                                  ),
                                  if(giftCardOrderCtrl.serviceDetails.first.data != null && giftCardOrderCtrl.serviceDetails.first.data!.length > 3)
                                  SizedBox(height: 20.h),


                                  if(giftCardOrderCtrl.serviceDetails.first.data != null && giftCardOrderCtrl.serviceDetails.first.data!.length > 3)
                                  TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,

                                    controller:
                                        giftCardOrderCtrl.codeController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Required";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'ادخل الكود',
                                      prefixIcon: Icon(Icons.code),
                                      contentPadding: EdgeInsets.all(20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  if(giftCardOrderCtrl.serviceDetails.first.data != null)
                                  SizedBox(height: 20.h),
                                  TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,

                                    controller:
                                        giftCardOrderCtrl.numberController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Required";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'ادخل الرقم',
                                      prefixIcon: Icon(Icons.numbers),
                                      contentPadding: EdgeInsets.all(20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  TextFormField(
                                    controller:
                                        giftCardOrderCtrl.amountController,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Required";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'القيمة المالية',
                                      prefixIcon: Icon(Icons.money),
                                      contentPadding: EdgeInsets.all(20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    children: [
                                      Text(
                                        'القيمة المقطوعة:',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Get.isDarkMode
                                                ? Colors.blueGrey.shade700
                                                : Colors.grey[300],
                                          ),
                                          child: Center(
                                            child: Text(
                                              giftCardOrderCtrl.amountController.text.isEmpty  ?'0.0' : giftCardOrderCtrl.amountController.text,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  AppButton(
                                    text: "دفع",
                                    onTap: () {
                                      if (giftCardOrderCtrl
                                          .formKey.currentState!
                                          .validate()) {
                                        giftCardOrderCtrl.CreateMyOffer(subcat_id: catId);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

BoxDecoration kDecorationBoxShadow({
  Color? color,
  Color? colorShadow,
  double blurRadius = 5,
  double spreadRadius = 4,
  double radius = 12,
  BorderRadius? borderRadius,
  Color? borderColor,
  double? borderWidth,
  Offset offset = const Offset(0, 0),
  required context,
}) {
  return BoxDecoration(
    color: color ?? (Get.isDarkMode ? Colors.black26 : Colors.white),
    borderRadius: borderRadius ?? BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: colorShadow ??
            (Get.isDarkMode
                ? Colors.black.withOpacity(0)
                : Color(0xff000000).withOpacity(0.05)),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: offset,
      ),
    ],
    border: Border.all(
      color: borderColor ??
          (Get.isDarkMode ? AppColors.darkBgColor : AppColors.black5),
      width: borderWidth ?? 0,
      style: BorderStyle.solid,
    ),
  );
}

class VacShimmer extends StatelessWidget {
  const VacShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: kDecorationBoxShadow(context: context),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    child: SizedBox(
                      height: 150.h,
                      width: double.infinity,
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      width: 70,
                      height: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
