import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/data/source/check_status.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/edit_sell_post_model.dart';
import '../data/repositories/edit_post_repo.dart';
import '../utils/services/helpers.dart';
import 'sellPost_list_controller.dart';

class EditPostController extends GetxController {
  static EditPostController get to => Get.find<EditPostController>();
  String priceVal = "0.0";
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController messageCtrl = TextEditingController();

  bool isLoading = false;
  List<EditSellPostModel> editPostList = [];
  List<DynamicCategoryField> dynamicFormList = [];
  List<DynamicCategoryField> dynamicPostSpecificationList = [];
  Future getEditPost({required String id}) async {
    isLoading = true;
    update();
    http.Response response = await EditPostRepo.getEditPost(id: id);
    isLoading = false;
    editPostList = [];
    dynamicFormList = [];
    dynamicPostSpecificationList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        Map<String, dynamic> sellPost = data['message']['sellPost'];
        editPostList.add(EditSellPostModel.fromJson(data));
        if (editPostList.isNotEmpty) {
          sellChargeParcentage = editPostList[0].message!.sellPost == null
              ? "0.00"
              : editPostList[0].message!.sellPost!.sellCharge.toString();
          titleCtrl.text = editPostList[0].message!.sellPost!.title.toString();
          priceCtrl.text = editPostList[0].message!.sellPost!.price.toString();
          descriptionCtrl.text =
              editPostList[0].message!.sellPost!.details.toString();
          messageCtrl.text =
              editPostList[0].message!.sellPost!.comments.toString();
        }
        if (sellPost['credential'] != null && sellPost['credential'] is Map) {
          Map<String, dynamic> form = sellPost['credential'];
          form.forEach((key, value) {
            dynamicFormList.add(DynamicCategoryField(
              fieldName: value['field_name'],
              fieldValue: value['field_value'],
              type: value['type'],
              validation: value['validation'],
            ));
          });
        }
        if (sellPost['post_specification_form'] != null &&
            sellPost['post_specification_form'] is Map) {
          Map<String, dynamic> postSpecification =
              sellPost['post_specification_form'];
          postSpecification.forEach((key, value) {
            dynamicPostSpecificationList.add(DynamicCategoryField(
              fieldName: value['field_name'],
              fieldValue: value['field_value'],
              type: value['type'],
              validation: value['validation'],
            ));
          });
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      dynamicFormList = [];
      dynamicPostSpecificationList = [];
    }
  }

  //--------HOW MUCH YOU EARN---------//
  String sellChargeParcentage = "0.00";
  String earn = "0.00";
  String sellCharge = "0.00";
  calculateAmount() {
    if (priceVal.isEmpty) {
      sellCharge = ((0 * double.parse(sellChargeParcentage).toInt()) / 100)
          .toStringAsFixed(2);
      earn = (0.00 - double.parse(sellCharge)).toStringAsFixed(2);
    } else if (priceVal.isNotEmpty) {
      sellCharge =
          ((int.parse(priceVal) * double.parse(sellChargeParcentage).toInt()) /
                  100)
              .toStringAsFixed(2);
      earn = (double.parse(priceVal) - double.parse(sellCharge))
          .toStringAsFixed(2);
    }
    update();
  }

  bool isPostUpdating = false;
  Future updatePost(
      {required Map<String, String> fields,
      required BuildContext context,
      Iterable<http.MultipartFile>? fileList}) async {
    isPostUpdating = true;
    update();
    http.Response response =
        await EditPostRepo.updatePost(fields: fields, fileList: fileList);
    isPostUpdating = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        SellPostListController.to.resetDataAfterSearching();
        SellPostListController.to.getIdPurchaseList(page: 1, date: '');
        Navigator.of(context).pop();
        update();
      } else {
        if (data['message'] == 'Image could not be uploaded.') {
          selectedFilePaths.clear();
          files.clear();
        }
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  final List<String> _fileNames = [];

  FilePickerResult? result;
  List<dynamic> selectedFilePaths = []; // Store all selected file paths
  List<http.MultipartFile> files = [];

  Future<void> pickFiles() async {
    // Request storage permission
    final storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted) {
      try {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.image,
        );

        if (result != null) {
          if (kDebugMode) {
            // print("==============File paths: ${result!.paths}");
          }
          _fileNames.addAll(result!.paths.map((path) => path!));
          selectedFilePaths.addAll(result!.paths
              .whereType<String>()); // Add selected paths to the list
          for (int i = 0; i < selectedFilePaths.length; i++) {
            files.addAll([
              await http.MultipartFile.fromPath(
                  "image[$i]", selectedFilePaths[i]),
            ]);
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
              "Please grant Storage permission in app settings to use this feature.");
    }
  }

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> formFieldtextEditingControllerMap = {};
  List<DynamicCategoryField> formFieldfileType = [];
  List<DynamicCategoryField> formFieldrequiredFile = [];
  List<String> formFieldrequiredTypeFileList = [];

  Future formFieldfilterData() async {
    // check if the field type is text or textArea
    var textType =
        await dynamicFormList.where((e) => e.type != 'file').toList();

    for (var field in textType) {
      formFieldtextEditingControllerMap[field.fieldName!] =
          TextEditingController(text: field.fieldValue);
      print(field.fieldValue);
    }

    // check if the field type is file
    formFieldfileType =
        await dynamicFormList.where((e) => e.type == 'file').toList();
    // listing the all required file
    formFieldrequiredFile = await formFieldfileType
        .where((e) => e.validation == 'required')
        .toList();
    // add the required file name in a seperate list for validation
    for (var file in formFieldrequiredFile) {
      formFieldrequiredTypeFileList.add(file.fieldName!);
    }
  }

  Map<String, dynamic> formFielddynamicData = {};
  List<String> formFieldimgPathList = [];

  Future formFieldrenderDynamicFieldData() async {
    formFieldimgPathList.clear();
    formFieldtextEditingControllerMap.forEach((key, controller) {
      formFielddynamicData[key] = controller.text;
    });
    await Future.forEach(formFieldimagePickerResults.keys, (String key) async {
      String filePath = formFieldimagePickerResults[key]!.path;
      formFieldimgPathList.add(formFieldimagePickerResults[key]!.path);
      formFielddynamicData[key] =
          await http.MultipartFile.fromPath("", filePath);
    });

    // if (kDebugMode) {
    //   print("Posting data: $dynamicData");
    // }
  }

  XFile? formFieldpickedFile;
  Map<String, http.MultipartFile> formFieldfileMap = {};
  Map<String, XFile?> formFieldimagePickerResults = {};
  Future<void> formFieldpickFile(String fieldName) async {
    final storageStatus = await Permission.camera.request();

    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        final pickedImageFile =
            await picker.pickImage(source: ImageSource.camera);

        if (pickedImageFile != null) {
          formFieldimagePickerResults[fieldName] = pickedImageFile;
          final file = await http.MultipartFile.fromPath(
              fieldName, pickedImageFile.path);
          formFieldfileMap[fieldName] = file;

          if (formFieldrequiredTypeFileList.contains(fieldName)) {
            formFieldrequiredTypeFileList.remove(fieldName);
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

  //------------------let's manupulate the post specification data-----//
  Map<String, TextEditingController> postSpecificationtextEditingControllerMap =
      {};
  List<DynamicCategoryField> postSpecificationfileType = [];
  List<DynamicCategoryField> postSpecificationrequiredFile = [];
  List<String> postSpecificationrequiredTypeFileList = [];

  Future postSpecificationfilterData() async {
    // check if the field type is text or textArea
    var textType = await dynamicPostSpecificationList
        .where((e) => e.type != 'file')
        .toList();

    for (var field in textType) {
      postSpecificationtextEditingControllerMap[field.fieldName!] =
          TextEditingController(text: field.fieldValue);
    }
    // check if the field type is file
    postSpecificationfileType = await dynamicPostSpecificationList
        .where((e) => e.type == 'file')
        .toList();
    // listing the all required file
    postSpecificationrequiredFile = await postSpecificationfileType
        .where((e) => e.validation == 'required')
        .toList();
    // add the required file name in a seperate list for validation
    for (var file in postSpecificationrequiredFile) {
      postSpecificationrequiredTypeFileList.add(file.fieldName!);
    }
  }

  Map<String, dynamic> postSpecificationdynamicData = {};
  List<String> postSpecificationimgPathList = [];

  Future postSpecificationrenderDynamicFieldData() async {
    postSpecificationimgPathList.clear();
    postSpecificationtextEditingControllerMap.forEach((key, controller) {
      postSpecificationdynamicData[key] = controller.text;
    });
    await Future.forEach(postSpecificationimagePickerResults.keys,
        (String key) async {
      String filePath = postSpecificationimagePickerResults[key]!.path;
      postSpecificationimgPathList
          .add(postSpecificationimagePickerResults[key]!.path);
      postSpecificationdynamicData[key] =
          await http.MultipartFile.fromPath("", filePath);
    });

    // if (kDebugMode) {
    //   print("Posting data: $dynamicData");
    // }
  }

  XFile? postSpecificationpickedFile;
  Map<String, http.MultipartFile> postSpecificationfileMap = {};
  Map<String, XFile?> postSpecificationimagePickerResults = {};
  Future<void> postSpecificationpickFile(String fieldName) async {
    final storageStatus = await Permission.camera.request();

    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        final pickedImageFile =
            await picker.pickImage(source: ImageSource.camera);

        if (pickedImageFile != null) {
          postSpecificationimagePickerResults[fieldName] = pickedImageFile;
          final file = await http.MultipartFile.fromPath(
              fieldName, pickedImageFile.path);
          postSpecificationfileMap[fieldName] = file;

          if (postSpecificationrequiredTypeFileList.contains(fieldName)) {
            postSpecificationrequiredTypeFileList.remove(fieldName);
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
}

class DynamicCategoryField {
  dynamic fieldName;
  dynamic fieldValue;
  dynamic type;
  dynamic validation;
  DynamicCategoryField(
      {this.fieldName, this.fieldValue, this.type, this.validation});
}
