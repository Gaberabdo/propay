import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/giftCard_order_controller.dart';
import 'package:gamers_arena/routes/page_index.dart';
import 'package:gamers_arena/views/screens/my_orders/mtn_content.dart';
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

class ALLGames extends StatelessWidget {
  const ALLGames({
    super.key,
    required this.FilterName,
    required this.catId,
  });
  final String FilterName;
  final String catId;
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<GiftCardOrderController>();
    controller.getServicesBySubCategory(catId);
    return GetBuilder<GiftCardOrderController>(builder: (giftCardOrderCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Sub Category",
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
                    ? VacShimmer()
                    : giftCardOrderCtrl.category.isEmpty
                        ? Helpers.notFound()
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: giftCardOrderCtrl.category.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    if (FilterName == 'Games') {
                                      navigateToScreen(
                                        context,
                                        MyOfferDetailsScreen(
                                          id: giftCardOrderCtrl.category[i].id!,
                                        ),
                                      );
                                    }
                                    if (FilterName == 'Authority') {
                                      navigateToScreen(
                                        context,
                                        MTNContent(
                                          FilterName: FilterName,
                                          catId: giftCardOrderCtrl.category[i].id!,
                                        ),
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Container(
                                    height: 60.h,
                                    width: 40.w,
                                    decoration:
                                        kDecorationBoxShadow(context: context),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12.r),
                                            topRight: Radius.circular(12.r),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: PHPENDPOINT.subCatImage +
                                                giftCardOrderCtrl
                                                    .category[i].image!,
                                            height: 150.h,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text(
                                          giftCardOrderCtrl.category[i].arabicName!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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
