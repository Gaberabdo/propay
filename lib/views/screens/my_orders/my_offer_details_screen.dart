import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/config/dimensions.dart';
import 'package:gamers_arena/data/models/giftCard_details_model.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:gamers_arena/views/screens/my_orders/giftCard_order_screen.dart';
import 'package:gamers_arena/views/widgets/app_button.dart';
import 'package:gamers_arena/views/widgets/custom_appbar.dart';
import 'package:gamers_arena/views/widgets/custom_textfield.dart';
import 'package:gamers_arena/views/widgets/spacing.dart';
import 'package:gamers_arena/views/widgets/text_theme_extension.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/buy_id_controller.dart';
import '../../../controllers/my_offer_controller.dart';
import '../../../data/models/my_offer_details_model.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_textfield.dart';

RegExp hasArabic = RegExp(r'[\u0600-\u06FF]');
// Regex to check if text contains English letters
RegExp hasEnglish = RegExp(r'[a-zA-Z]');

class MyOfferDetailsScreen extends StatelessWidget {
  const MyOfferDetailsScreen({super.key, required this.id});
  final dynamic id;

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    final MyOfferController controllerT = Get.put(MyOfferController());
    controllerT.getMyOfferList(id);
    return GetBuilder<MyOfferController>(
      builder: (myOfferCtrl) {
        if (myOfferCtrl.isLoading) {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Helpers.appLoader(),
          );
        } else if (myOfferCtrl.serviceDetails.isEmpty) {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Center(
              child: Text("No data found", style: context.t.bodyLarge),
            ),
          );
        }
        var data = myOfferCtrl.serviceDetails.first;

        return Scaffold(
          appBar: const CustomAppBar(),
          body: SafeArea(
            child: ListView.builder(
              itemCount: data.data!.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            surfaceTintColor:
                                Get.isDarkMode ? Colors.black26 : Colors.white,
                            titlePadding: EdgeInsets.all(12),
                            contentPadding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'انشاء طلب ل ${data.data![index].name.toString()}',
                                ),
                                VSpace(20.h),
                                CustomTextField(
                                  hintext: 'Enter player id',
                                  controller: myOfferCtrl.playerId,
                                ),
                                VSpace(20.h),
                                AppButton(
                                  onTap: (myOfferCtrl.playerId.text.isEmpty)
                                      ? () {
                                          Helpers.showSnackBar(
                                            msg: 'Invalid player id',
                                          );
                                        }
                                      : () {
                                          myOfferCtrl.CreateMyOffer(
                                            MENA:data.data![index].name.toString() ,
                                            bill: data.data![index].cost.toString(),
                                            type: data.type,
                                            subcat_id: data.data![index].id.toString(),
                                          ).whenComplete(
                                            () {
                                              Navigator.pop(
                                                context,
                                              );
                                            },
                                          );
                                        },
                                  isLoading: myOfferCtrl.isLoadingOrder,
                                  text: 'تأكيد',
                                ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Text(
                                  'انشاء طلب',
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      height: 60.h,
                      decoration: kDecorationBoxShadow(context: context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.data![index].name.toString(),
                              style: t.bodyLarge?.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                            Text(
                              data.data![index].cost.toString(),
                              style: t.bodyLarge?.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
