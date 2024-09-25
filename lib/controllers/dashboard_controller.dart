import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamers_arena/data/repositories/dashboard_repo.dart';
import 'package:gamers_arena/data/source/dio.dart';
import 'package:gamers_arena/utils/services/localstorage/hive.dart';
import 'package:http/http.dart' as http;
import '../data/models/PhotoCarusel.dart';
import '../data/source/check_status.dart';
import '../routes/page_index.dart';
import '../utils/app_constants.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/keys.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find<DashboardController>();

  bool isLoading = false;

  String heading = "";
  String subHeading = "";
  String buttonName = "";
  String homeImage = "";

  String baseCurrencySymbol = "\$";
  String walletBalance = "0.00";
  String topup = "0";
  String voucher = "0";
  String giftCard = "0";
  String supportTicket = "0";
  List<DataSlider> dataSlider = [];
  Future getDashboardData() async {
    isLoading = true;
    update();
    try {
      var data = await DioFinalHelper.postData(
        method: PHPENDPOINT.photoCarusel,
        data: {
          "user_id": HiveHelp.read(Keys.uid),
        },
      );
      PhotoCarusel photoCarusel = PhotoCarusel.fromJson(data.data);
      dataSlider = photoCarusel.data!;
      isLoading = false;
      print('dataSlider ${dataSlider.length}');
      update();
    } on DioException catch (e) {
      isLoading = false;
      update();
      print('dataSlider ${e.type}');

      Helpers.showSnackBar(msg: e.message!);
    }
  }

  bool isUpdateProfile = false;

  TextEditingController newPassEditingController = TextEditingController();

  RxString newPassVal = "".obs;
  void validateUpdatePass() async {
    isUpdateProfile = true;
    update();
    try {
      var data = await DioFinalHelper.postData(
        method: PHPENDPOINT.chargeAccount,
        data: {
          "code": newPassEditingController.text,
          "user_id": HiveHelp.read(Keys.uid),
        },
      );

      var decode = jsonDecode(data.data);
      Helpers.showSnackBar(msg: decode['msg']);
      newPassEditingController.clear();
      isUpdateProfile = false;
      update();
    } on DioException catch (e) {
      isUpdateProfile = false;
      print(e.message);
      var decode = jsonDecode(e.response!.data);

      Helpers.showSnackBar(msg: decode['msg']);
      update();
    }
  }

  bool currentPassShow = true;
  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  currentPassObscure() {
    currentPassShow = !currentPassShow;
    update();
  }

  newPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  confirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  @override
  void onInit() {
    getDashboardData();
    super.onInit();
  }
}
