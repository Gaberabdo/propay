import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/repositories/profile_repo.dart';
import '../data/repositories/verification_repo.dart';
import '../data/source/check_status.dart';
import '../utils/services/helpers.dart';

class VerificationController extends GetxController {
  bool isLoading = false;
  //----------------Two Factor Security------------//
  var TwoFAEditingController = TextEditingController();
  bool isTwoFactorEnabled = false;
  String secretKey = '';
  String qrCodeUrl = '';
  Future getTwoFa() async {
    isLoading = true;
    update();
    http.Response response = await VerificationRepo.getTwoFa();
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        isTwoFactorEnabled = data['message']['twoFactorEnable'] ?? false;
        update();
        if (data['message']['twoFactorEnable'] == false) {
          secretKey = data['message']['secret'] ?? "";
          qrCodeUrl = data['message']['qrCodeUrl'] ?? "";
          update();
        } else if (data['message']['twoFactorEnable'] == true) {
          secretKey = data['message']['previousCode'] ?? "";
          qrCodeUrl = data['message']['previousQR'] ?? "";
          update();
        }

        update();
      } else {
      }
    } else {
      
    }
  }

  bool isVerifying = false;
  Future enableTwoFa({Map<String, dynamic>? fields, context}) async {
    isVerifying = true;
    update();
    http.Response response = await VerificationRepo.enableTwoFa(fields: fields);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        getTwoFa();
        Navigator.of(context).pop();
        TwoFAEditingController.clear();
      }
      update();
    } else {
    }
  }

  Future disableTwoFa({Map<String, dynamic>? fields, context}) async {
    isVerifying = true;
    update();
    http.Response response =
        await VerificationRepo.disableTwoFa(fields: fields);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        getTwoFa();
        Navigator.of(context).pop();
        TwoFAEditingController.clear();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  final field1 = TextEditingController();
  final field2 = TextEditingController();
  final field3 = TextEditingController();
  final field4 = TextEditingController();
  final field5 = TextEditingController();
  final field6 = TextEditingController();

  //-----------------mail verify-------------------//
  Future mailVerify({required String code, context}) async {
    isVerifying = true;
    update();
    http.Response response = await VerificationRepo.mailVerify(code: code);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.bottomNavBar);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //-----------------sms verify-------------------//
  Future smsVerify({required String code, context}) async {
    isVerifying = true;
    update();
    http.Response response = await VerificationRepo.smsVerify(code: code);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.bottomNavBar);
      }
      update();
    } else {
      
    }
  }

  //-----------------twofa verify-------------------//
  final twoFaController = TextEditingController();
  Future twoFaVerify({required String code, context}) async {
    isVerifying = true;
    update();
    http.Response response = await VerificationRepo.twoFaVerify(code: code);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.bottomNavBar);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //-----------------resend code-------------------//
  bool isResending = false;
  Future resendCode({required String type, context}) async {
    isResending = true;
    update();
    http.Response response = await VerificationRepo.resendCode(type: type);
    isResending = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
      }
      update();
    } else {
      
    }
  }

  //----------------address verify-----------------//
  String imagePath = "";
  XFile? pickedImageFile;

  Future<void> pickFiles() async {
    final storageStatus = await Permission.camera.request();
    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        pickedImageFile = await picker.pickImage(source: ImageSource.gallery);

        imagePath = pickedImageFile!.path;
        update();
      } catch (e) {
        Helpers.showSnackBar(msg: e.toString());
      }
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant camera permission in app settings to use this feature.");
    }
  }

  Future addressVerify({required String filePath, context}) async {
    isLoading = true;
    update();
    http.Response response = await VerificationRepo.addressVerification(
        files: await http.MultipartFile.fromPath('addressProof', filePath));
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        imagePath = '';
        pickedImageFile = null;
        Navigator.of(context).pop();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //------------------identity verification-------------------//
  List<CategoryNameModel> categoryNameList = [];
  List<VerificationDFormModel> verificationList = [];
  String userIdentityVerifyMsg = "";
  bool userIdentityVerifyFromShow = false;
  Future getVerification() async {
  }

  bool isIdentitySubmitting = false;
  Future submitVerification(
      {required Map<String, String> fields,
      required BuildContext context,
      required Iterable<http.MultipartFile>? fileList}) async {
    isIdentitySubmitting = true;
    update();
    http.Response response = await VerificationRepo.submitVerification(
        fields: fields, fileList: fileList);
    isIdentitySubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Navigator.of(context).pop();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<VerificationDFormModel> fileType = [];
  List<VerificationDFormModel> requiredFile = [];
  List<String> requiredTypeFileList = [];

  Future filterData() async {
    // check if the field type is text or textArea
    var textType = await selectedCategoryDynamicList
        .where((e) => e.servicesForm!.type != 'file')
        .toList();
    var textForm = textType.map((e) => e.servicesForm);

    for (var field in textForm) {
      textEditingControllerMap[field!.fieldName!] = TextEditingController();
    }

    // check if the field type is file
    fileType = await selectedCategoryDynamicList
        .where((e) => e.servicesForm!.type == 'file')
        .toList();
    // listing the all required file
    requiredFile = await fileType
        .where((e) => e.servicesForm!.validation == 'required')
        .toList();
    var fieldForm = requiredFile.map((e) => e.servicesForm);
    // add the required file name in a seperate list for validation
    for (var file in fieldForm) {
      requiredTypeFileList.add(file!.fieldName!);
    }
  }

  Map<String, dynamic> dynamicData = {};
  List<String> imgPathList = [];

  Future renderDynamicFieldData() async {
    imgPathList.clear();
    textEditingControllerMap.forEach((key, controller) {
      dynamicData[key] = controller.text;
    });
    await Future.forEach(imagePickerResults.keys, (String key) async {
      String filePath = imagePickerResults[key]!.path;
      imgPathList.add(imagePickerResults[key]!.path);
      dynamicData[key] = await http.MultipartFile.fromPath("", filePath);
    });

    // if (kDebugMode) {
    //   print("Posting data: $dynamicData");
    // }
  }

  final formKey = GlobalKey<FormState>();
  XFile? pickedFile;
  Map<String, http.MultipartFile> fileMap = {};
  Map<String, XFile?> imagePickerResults = {};
  Future<void> pickFile(String fieldName) async {
    final storageStatus = await Permission.camera.request();

    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        final pickedImageFile =
            await picker.pickImage(source: ImageSource.camera);

        if (pickedImageFile != null) {
          imagePickerResults[fieldName] = pickedImageFile;
          final file = await http.MultipartFile.fromPath(
              fieldName, pickedImageFile.path);
          fileMap[fieldName] = file;

          if (requiredTypeFileList.contains(fieldName)) {
            requiredTypeFileList.remove(fieldName);
          }
          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error while picking files: $e");
        }
      }
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant camera permission in app settings to use this feature.");
    }
  }

  refreshIndentityVerificationDynamicData() {
    selectedCategoryDynamicList.clear();
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    requiredTypeFileList.clear();
    pickedImageFile = null;
    fileMap.clear();
    selectedOption = "";
  }
  //--------------------------------------------------//

  String selectedOption = "";
  String identityType = "";
  List<VerificationDFormModel> selectedCategoryDynamicList = [];
  onChanged(value) {
    // get the selected category slug for submitting identity type
    List<CategoryNameModel> selectedCategory =
        categoryNameList.where((e) => e.categoryName == value).toList();
    selectedOption = value;
    identityType = selectedCategory.first.slug!;
    // clear the whole data initially
    refreshData();
    // let's render the data
    filterCategoryData(value);
    update();
  }

  Future filterCategoryData(value) async {
    selectedCategoryDynamicList =
        await verificationList.where((e) => e.categoryName == value).toList();
    await filterData();
  }

  refreshData() {
    selectedCategoryDynamicList.clear();
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    requiredTypeFileList.clear();
    pickedImageFile = null;
    fileMap.clear();
  }
}

class VerificationDFormModel {
  dynamic categoryName;
  VerificationServicesForm? servicesForm;

  VerificationDFormModel({
    this.categoryName,
    this.servicesForm,
  });
}

class VerificationServicesForm {
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic fieldLength;
  dynamic lengthType;
  dynamic validation;

  VerificationServicesForm({
    this.fieldName,
    this.fieldLevel,
    this.type,
    this.fieldLength,
    this.lengthType,
    this.validation,
  });
}

class CategoryNameModel {
  dynamic categoryName;
  dynamic slug;
  CategoryNameModel({this.categoryName, this.slug});
}
