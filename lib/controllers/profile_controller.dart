import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gamers_arena/data/repositories/profile_repo.dart';
import 'package:gamers_arena/data/source/dio.dart';
import 'package:gamers_arena/utils/app_constants.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/app_colors.dart';
import '../data/models/profile_model.dart';
import '../data/source/check_status.dart';
import '../routes/routes_name.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();

  bool isLoading = false;

  // -----------------------edit profile--------------------------
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();

  String userPhoto = '';
  String userName = '';
  String join_date = '';
  String addressVerificationMsg = "";
  String selectedLanguage = "";
  String selectedLanguageId = "1";
  bool isLanguageSelected = false;
  String userEmail = "";
  String balance = "";

  ProfileModel? profileModel;
  Future getProfile() async {
    isLoading = true;
    update();
    try {
      dynamic response = await DioFinalHelper.postData(
        method: PHPENDPOINT.userInfoEndPoint,
        data: {
          'user_id': HiveHelp.read(Keys.uid),
        },
      );

      Map decode = jsonDecode(response.data);
      profileModel = ProfileModel.fromJson(decode['data'].first);
      userName = profileModel!.firstName! + ' ' + profileModel!.lastName!;
      firstNameEditingController.text = profileModel!.firstName!;
      emailEditingController.text = profileModel!.email!;
      phoneNumberEditingController.text = profileModel!.phone!;
      userEmail = profileModel!.email!;
      balance = profileModel!.balance!;
      addressEditingController.text = profileModel!.address!;
      isLoading = false;
      update();
    } on DioException catch (e) {
      print(e);
      isLoading = false;
      Helpers.showSnackBar(msg: e.message!);
      update();
    }
  }
  bool isUpdateProfile = false;

  Future<void> updateProfile() async {
    // Set the state indicating profile update has started
    isUpdateProfile = true;
    update();

    try {
      // Make the API call to update the profile
      await DioFinalHelper.postData(
        method: PHPENDPOINT.userUpdateInfoEndPoint,
        data: jsonEncode({
          "user_id": HiveHelp.read(Keys.uid),
          "first_name": firstNameEditingController.text,
          "last_name": "",
          "username": "",
          "address": addressEditingController.text,
          "password": newPassEditingController.text,
          "FCM_token": "cyjAmicmRKydY3G3cQdspA:APA91bGn3UJT7ZpIWKDJloVc1Pi_MrZZ5H8922xLaTtQOe-1H60V9u4-dyJcS3YUDYu-qxJrC3z1-LFCNV3zHR-hAY9z0y3vtJl_p0zQjAPdlsneJcacOrFdavOOPbFxO2aeEn-MZSoi",
        }),
      );

      // Use a post-frame callback to ensure UI updates occur after the build process
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isUpdateProfile = false;
        Helpers.showSnackBar(
          msg: "Profile Updated Successfully",
          title: 'Success',
          bgColor: AppColors.greenColor,
        );
        Get.offAllNamed(RoutesName.bottomNavBar);
        getProfile();
        update(); // Make sure to update after showing the success message
      });

    } on DioException catch (e) {
      // Handle API error
      isUpdateProfile = false;
      dynamic data = e.response?.data;
      Map dataMap = jsonDecode(data);
      String msg = dataMap['msg'];

      // Use post-frame callback for safe update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Helpers.showSnackBar(msg: msg);
        update();
      });
    }
  }


  //--------------------------change password--------------------------
  TextEditingController newPassEditingController = TextEditingController();

  RxString newPassVal = "".obs;

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

  void validateUpdatePass() async {
    await updateProfile();
  }

}
