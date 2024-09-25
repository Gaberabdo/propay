import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as net;
import 'package:flutter/material.dart';
import 'package:gamers_arena/data/models/profile_model.dart';
import 'package:gamers_arena/data/repositories/auth_repo.dart';
import 'package:gamers_arena/data/source/check_status.dart';
import 'package:gamers_arena/data/source/dio.dart';
import 'package:gamers_arena/utils/app_constants.dart';
import 'package:gamers_arena/utils/services/helpers.dart';
import 'package:gamers_arena/utils/services/localstorage/hive.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../routes/routes_name.dart';
import '../utils/services/localstorage/keys.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  bool isLoading = false;

  // -----------------------sign in--------------------------
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController signInPassEditingController = TextEditingController();

  String userNameVal = "";
  String singInPassVal = "";
  bool isRemember = false;

  clearSignInController() {
    userNameEditingController.clear();
    signInPassEditingController.clear();
    userNameVal = "";
    singInPassVal = "";
  }

  Future login() async {
    isLoading = true;
    update();

    try {
      var data = net.FormData.fromMap({
        'email_phone': userNameEditingController.text,
        'password': signInPassEditingController.text,
        'FCM_token': ''
      });

      net.Response response = await DioFinalHelper.postData(
        method: PHPENDPOINT.loginEndPoint,
        data: data,
      );

      isLoading = false;
      update();

      Map decode = jsonDecode(response.data);
      ProfileModel dataMap = ProfileModel.fromJson(decode['data']);

      print(dataMap.toJson());
      HiveHelp.write(Keys.token, dataMap.token!);
      HiveHelp.write(Keys.uid, dataMap.id!);
      Get.offAllNamed(RoutesName.bottomNavBar);
      clearSignInController();
      update();
    } on DioException catch (e) {
      isLoading = false;
      update();
      dynamic data = e.response!.data;
      Map dataMap = jsonDecode(data);
      String msg = dataMap['msg'];

      Helpers.showSnackBar(msg: msg);
      update();
      print("Failed to Load $e");
    }
  }

  // -----------------------sign up--------------------------
  TextEditingController signupFirstNameEditingController =
      TextEditingController();
  TextEditingController signupLastNameEditingController =
      TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController signUpUserNameEditingController =
      TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController signUpPassEditingController = TextEditingController();
  TextEditingController confirmPassEditingController = TextEditingController();

  String signupFirstNameVal = "";
  String signupLastNameVal = "";
  String signUpUserNameVal = "";
  String emailVal = "";
  String addressVal = "";
  String phoneNumberVal = "";
  String signUpPassVal = "";
  String signUpConfirmPassVal = "";
  String countryCode = 'US';
  String phoneCode = '+1';

  clearSignUpController() {
    signupFirstNameEditingController.clear();
    signupLastNameEditingController.clear();
    emailEditingController.clear();
    signUpUserNameEditingController.clear();
    phoneNumberEditingController.clear();
    signUpPassEditingController.clear();
    confirmPassEditingController.clear();
    signupFirstNameVal = "";
    signupLastNameVal = "";
    signUpUserNameVal = "";
    emailVal = "";
    phoneNumberVal = "";
    signUpPassVal = "";
    signUpConfirmPassVal = "";
  }

  Future register() async {
    isLoading = true;
    update();

    try {
      net.Response response = await DioFinalHelper.postData(
        method: PHPENDPOINT.registerEndPoint,
        data: {
          "first_name":signupFirstNameVal,
          "last_name": "",
          "username": "",
          "email":emailVal,
          "phone": phoneNumberVal,
          "password": signUpPassVal,
          "address": addressVal
        },
      );

      isLoading = false;
      update();

      Map decode = jsonDecode(response.data);
      ProfileModel dataMap = ProfileModel.fromJson(decode['data'].first);

      print(dataMap.toJson());
      HiveHelp.write(Keys.token, dataMap.token!);
      HiveHelp.write(Keys.uid, dataMap.id!);
      Get.offAllNamed(RoutesName.bottomNavBar);
      clearSignInController();
      update();
    } on DioException catch (e) {
      isLoading = false;
      update();
      dynamic data = e.response!.data;
      Map dataMap = jsonDecode(data);
      String msg = dataMap['msg'];

      Helpers.showSnackBar(msg: msg);
      update();
      print("Failed to Load $e");
    }
  }

  //------------------------forgot password----------------------
  TextEditingController forgotPassEmailEditingController =
      TextEditingController();
  TextEditingController forgotPassNewPassEditingController =
      TextEditingController();
  TextEditingController forgotPassConfirmPassEditingController =
      TextEditingController();
  TextEditingController otpEditingController1 = TextEditingController();
  TextEditingController otpEditingController2 = TextEditingController();
  TextEditingController otpEditingController3 = TextEditingController();
  TextEditingController otpEditingController4 = TextEditingController();
  TextEditingController otpEditingController5 = TextEditingController();

  String forgotPassEmailVal = "";
  String forgotPassNewPassVal = "";
  String forgotPassConfirmPassVal = "";
  String otpVal1 = "";
  String otpVal2 = "";
  String otpVal3 = "";
  String otpVal4 = "";
  String otpVal5 = "";

  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  forgotPassNewPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  forgotPassConfirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  clearForgotPassVal() {
    forgotPassEmailEditingController.clear();
    forgotPassEmailVal = "";
  }

  clearForgotPassNewPassVal() {
    forgotPassNewPassEditingController.clear();
    forgotPassConfirmPassEditingController.clear();
    forgotPassNewPassVal = "";
    forgotPassConfirmPassVal = "";
  }

  clearForgotPassOtpVal() {
    otpEditingController1.clear();
    otpEditingController2.clear();
    otpEditingController3.clear();
    otpEditingController4.clear();
    otpEditingController5.clear();
    otpVal1 = "";
    otpVal2 = "";
    otpVal3 = "";
    otpVal4 = "";
    otpVal5 = "";
  }

  Future forgotPass({bool? isFromOtpPage = false}) async {
    if (isFromOtpPage == false) {
      isLoading = true;
      update();
    }
    http.Response response = await AuthRepo.forgotPass(data: {
      "email": forgotPassEmailEditingController.text,
    });
    if (isFromOtpPage == false) {
      isLoading = false;
      update();
    }
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.toNamed(RoutesName.otpScreen);
      }
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //----------------------verify email-----------------
  ///COUNT DOWN TIMER
  int counter = 60;
  late Timer timer;
  bool isStartTimer = false;
  Duration duration = const Duration(seconds: 1);

  void startTimer() {
    timer = Timer.periodic(duration, (timer) {
      if (counter > 0) {
        counter -= 1;
        isStartTimer = true;
        update();
      } else {
        timer.cancel();
        counter = 60;
        isStartTimer = false;
        update();
      }
    });
  }

  Future geCode() async {
    isLoading = true;
    update();
    http.Response response = await AuthRepo.getCode(data: {
      "email": forgotPassEmailEditingController.text,
      "code": '${otpVal1 + otpVal2 + otpVal3 + otpVal4}',
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.toNamed(RoutesName.createNewPassScreen);
        clearForgotPassOtpVal();
      }
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  Future updatePass() async {
    isLoading = true;
    update();
    http.Response response = await AuthRepo.updatePass(data: {
      "password": forgotPassNewPassEditingController.text,
      "password_confirmation": forgotPassConfirmPassEditingController.text,
      "email": forgotPassEmailEditingController.text,
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.loginScreen);
        clearForgotPassNewPassVal();
      }
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }
}
