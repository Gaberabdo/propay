import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/controllers/bindings/controller_index.dart';
import 'package:gamers_arena/data/models/center_model.dart';
import 'package:gamers_arena/data/source/dio.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:gamers_arena/views/screens/my_orders/giftCard_order_screen.dart';
import 'package:gamers_arena/views/screens/payment_and_addFund/transaction_screen.dart';
import 'package:gamers_arena/views/screens/profile/profile_setting_screen.dart';
import 'package:gamers_arena/views/widgets/app_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';
import '../home/charging_account.dart';
import '../home/home_screen.dart';

class AccreditedScreen extends StatefulWidget {
  AccreditedScreen({super.key});

  @override
  State<AccreditedScreen> createState() => _AccreditedScreenState();
}

class _AccreditedScreenState extends State<AccreditedScreen> {
  bool isCollapsed = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<CenterModel> CenterModels = [];
  List<CenterModel> filteredCenterModels = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCenterModels();
  }

  Future<void> loadCenterModels() async {
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));
    final res = await DioFinalHelper.postData(
      method: PHPENDPOINT.searchCenters,
      data: {
        'user_id': HiveHelp.read(Keys.uid),
      },
    );

    Map decode = jsonDecode(res.data);

    List<dynamic> CenterModelsData = decode['data'];

    setState(() {
      CenterModels =
          CenterModelsData.map((data) => CenterModel.fromJson(data)).toList();
      filteredCenterModels = CenterModels;
      isLoading = false;
    });
  }

  void filterCenterModels(String query) {
    setState(() {
      filteredCenterModels = CenterModels.where((CenterModel) =>
              CenterModel.name.toLowerCase().contains(query.toLowerCase()) ||
              CenterModel.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.delete<WithdrawController>();
    Get.delete<AddFundController>();
    Get.put(ProfileController());
    Get.put(DashboardController());

    return GetBuilder<ProfileController>(
      builder: (profileCtrl) {
        return GetBuilder<DashboardController>(
          builder: (dashboardCtrl) {
            return Scaffold(
              key: scaffoldKey,
              appBar: buildAppbar(profileCtrl),
              drawer: buildDrawer(t, storedLanguage, context),
              body: buildChargingAccount(t, dashboardCtrl),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(height: 140),
          );
        },
      ),
    );
  }

  Widget _buildCentersList() {
    return ListView.builder(
      itemCount: filteredCenterModels.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var center = filteredCenterModels[index];
        return Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? AppColors.imageBgColor
                  : AppColors.fillColorColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    center.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color:
                              Get.isDarkMode ? Colors.white70 : Colors.black54,
                          size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          center.address,
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone,
                          color:
                              Get.isDarkMode ? Colors.white70 : Colors.black54,
                          size: 16),
                      SizedBox(width: 4),
                      Text(
                        center.phone,
                        style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.white70
                                : Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.smartphone,
                          color:
                              Get.isDarkMode ? Colors.white70 : Colors.black54,
                          size: 16),
                      SizedBox(width: 4),
                      Text(
                        center.mobile,
                        style: TextStyle(
                          color:
                              Get.isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
      title: "مركزنا الموجودة بالخدمة",
    );
  }

  buildChargingAccount(TextTheme t, DashboardController controller) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(RoutesName.bottomNavBar);

        return false;
      },
      child: Padding(
        padding: Dimensions.kDefaultPadding,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  height: 45.h,
                  isPrefixIcon: true,
                  isSuffixIcon: true,
                  isSuffixBgColor: true,
                  prefixIcon: 'search',
                  suffixIcon: 'filter',
                  hintext: 'ادخل اسم المركز او العنوان',
                  onChanged: (v) {
                    filterCenterModels(v);
                  },
                  controller: searchController,
                ),
              ),
              isLoading ? _buildShimmerEffect() : _buildCentersList(),
            ],
          ),
        ),
      ),
    );
  }
}
