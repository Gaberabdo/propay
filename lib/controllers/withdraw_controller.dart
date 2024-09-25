import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/controllers/bindings/controller_index.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/bank_from_bank_model.dart';
import '../data/models/bank_from_currency_model.dart' as currency;
import '../data/models/payout_model.dart';
import '../data/models/bank_from_bank_model.dart' as bank;
import '../data/repositories/withdraw_repo.dart';
import '../data/source/check_status.dart';
import '../routes/page_index.dart';
import '../utils/services/helpers.dart';

class WithdrawController extends GetxController {
  static WithdrawController get to => Get.find<WithdrawController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  TextEditingController amountCtrl = TextEditingController();

  List<DynamicFieldModel> dynamicList = [];
  List<DynamicFieldModel> selectedDynamicList = [];
  List<PayoutGateways> paymentGatewayList = [];
  List<String> flutterwaveTransferList = [];
  List<String> flutterwaveCurrencyList = [];
  List<String> paystackCurrencyList = [];
  List<OtherGatewayCurrencyModel> otherGatewayCurrencyList = [];
  Future getPayouts() async {
    _isLoading = true;

    update();
    http.Response response = await WithdrawRepo.getPayouts();
    _isLoading = false;
    paymentGatewayList = [];
    dynamicList = [];
    flutterwaveTransferList = [];
    flutterwaveCurrencyList = [];
    paystackCurrencyList = [];
    otherGatewayCurrencyList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        paymentGatewayList
            .addAll(PayoutModel.fromJson(data).message!.gateways!);
        // filter the dynamic field data
        List list = data['message']['gateways'];
        for (var i in list) {
          if (i['dynamicForm'] != null && i['dynamicForm'] is Map) {
            // dynamic field
            Map<String, dynamic> dForm = i['dynamicForm'];
            dForm.forEach((key, value) {
              if (value['field_name'] != null && value['field_level'] != null) {
                dynamicList.add(DynamicFieldModel(
                  name: i['name'],
                  fieldName: value['field_name'],
                  fieldLevel: value['field_level'],
                  type: value['type'],
                  validation: value['validation'],
                ));
              } else if (value['name'] != null && value['label'] != null) {
                dynamicList.add(DynamicFieldModel(
                  name: i['name'],
                  fieldName: value['name'],
                  fieldLevel: value['label'],
                  type: value['type'],
                  validation: value['validation'],
                ));
              }
            });
          }
          // if the payment gateway is flutterwave
          if (i['name'] == "Flutterwave") {
            if (i['bankName'] is List && i['bankName'] != null) {
              for (var j in i['bankName']) {
                flutterwaveTransferList.add(j);
              }
            }
            if (i['supportedCurrency'] != null &&
                i['supportedCurrency'] is Map) {
              Map<String, dynamic> currencyMap = i['supportedCurrency'];

              currencyMap.forEach((key, value) {
                flutterwaveCurrencyList.add(value);
              });
            }
          }
          // if the payment gateway is paystack
          if (i['name'] == "Paystack") {
            if (i['supportedCurrency'] != null &&
                i['supportedCurrency'] is Map) {
              Map<String, dynamic> currencyMap = i['supportedCurrency'];

              currencyMap.forEach((key, value) {
                paystackCurrencyList.add(value);
              });
            }
          }
          if (i['supportedCurrency'] != null && i['supportedCurrency'] is Map) {
            Map<String, dynamic> currencyMap = i['supportedCurrency'];

            currencyMap.forEach((key, value) {
              otherGatewayCurrencyList.add(OtherGatewayCurrencyModel(
                  gatewayName: i['name'], currency: value));
            });
          }
        }

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);

        update();
      }
    } else {
      Helpers.showSnackBar(msg: response.body);

      update();
    }
  }

  int selectedGatewayIndex = -1;
  List<PayoutGateways> searchedGatewayItem = [];
  bool isGatewaySearching = false;
  TextEditingController gatewaySearchCtrl = TextEditingController();
  queryPaymentGateway(String v) {
    searchedGatewayItem = paymentGatewayList
        .where((e) => e.name.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    selectedGatewayIndex = -1;
    if (v.isEmpty) {
      isGatewaySearching = false;
      searchedGatewayItem.clear();
      update();
    } else if (v.isNotEmpty) {
      isGatewaySearching = true;
      update();
    }
    update();
  }

  int gatewayId = 0;
  String gatewayName = "";
  String minAmount = "0.00";
  String maxAmount = "0.00";
  String charge = "0.00";
  String currencySymbol = "";
  getSelectedGatewayData(index) {
    var data = paymentGatewayList[index];
    gatewayId = data.id;
    gatewayName = data.name;
    minAmount = double.parse(data.minAmount.toString()).toStringAsFixed(2);
    maxAmount = double.parse(data.maxAmount.toString()).toStringAsFixed(2);
    charge = double.parse(data.fixedCharge.toString()).toStringAsFixed(2);
    currencySymbol = data.symbol.toString();
    // get selected currencyList for payout submit
    selectedotherGatewayCurrencyList = otherGatewayCurrencyList
        .where((e) => e.gatewayName == data.name)
        .toList();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getPayouts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //----------PAYOUT SUBMIT----------//
  bool isPayoutSubmitting = false;
  List<OtherGatewayCurrencyModel> selectedotherGatewayCurrencyList = [];
  var selectedotherGatewayCurrencyValue = null;
  var selectedPaypalValue = null;
  Future submitPayout(
      {required Map<String, String> fields,
      required BuildContext context,
      required Iterable<http.MultipartFile>? fileList}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response =
        await WithdrawRepo.payoutSubmit(fields: fields, fileList: fileList);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        refreshDynamicData();
        BottomNavController.to.changeScreen(0);
        BottomNavController.to.update();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (Route<dynamic> route) => false);
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //------------FLUTTER WAVE---------//
  var flutterWaveSelectedTransfer = null;
  var flutterWaveSelectedCurrency = null;
  var flutterWaveSelectedBank = null;
  String flutterwaveSelectedBankNumber = "0";
  List<bank.Data> bankFromBankList = [];
  List<String> bankFromBankDynamicList = [];
  Map<String, TextEditingController> bankFromBanktextEditingControllerMap = {};
  Future getBankFromBank({required String bankName}) async {
    _isLoading = true;
    update();
    http.Response response =
        await WithdrawRepo.getBankFromBank(bankName: bankName);
    bankFromBankList = [];
    bankFromBankDynamicList = [];
    _isLoading = false;
    update();
    var data = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        if (data['message']['bank'] != null &&
            data['message']['bank']['data'] != null) {
          bankFromBankList
              .addAll(BankFromBankModel.fromJson(data).message!.bank!.data!);
        }
        // get the dynamic input_form list
        // "input_form": {
        //     "account_number": "",
        //     "narration": "",
        // }
        if (data['message']['input_form'] != null &&
            data['message']['input_form'] is Map) {
          Map<String, dynamic> map = data['message']['input_form'];
          map.forEach((key, value) {
            bankFromBankDynamicList.add(key);
            bankFromBanktextEditingControllerMap[key] = TextEditingController();
          });
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  Future submitFlutterwavePayout(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response =
        await WithdrawRepo.flutterwaveSubmit(fields: fields);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);

      if (data['status'] == 'success') {
        refreshDynamicData();
        BottomNavController.to.changeScreen(0);
        BottomNavController.to.update();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (Route<dynamic> route) => false);
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //------------PAYSTACK---------//
  var paystackSelectedBank = null;
  var paystackSelectedCurrency = null;
  String paystackSelectedBankNumber = "0";
  String paystackSelectedType = "";
  List<currency.Data> bankFromCurrencyList = [];
  Future getBankFromCurrency({required String currencyCode}) async {
    _isLoading = true;
    update();
    http.Response response =
        await WithdrawRepo.getBankFromCurrency(currencyCode: currencyCode);
    bankFromCurrencyList = [];
    _isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        if (data['message']['data'] != null &&
            data['message']['data'] is List) {
          bankFromCurrencyList.addAll(
              currency.BankFromCurrencyModel.fromJson(data).message!.data!);
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  Future submitPaystackPayout(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response = await WithdrawRepo.paystackSubmit(fields: fields);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        refreshDynamicData();
        BottomNavController.to.changeScreen(0);
        BottomNavController.to.update();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (Route<dynamic> route) => false);
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<DynamicFieldModel> fileType = [];
  List<DynamicFieldModel> requiredFile = [];
  List<String> requiredTypeFileList = [];

  Future filterData() async {
    // check if the field type is text or textArea
    var textType =
        await selectedDynamicList.where((e) => e.type != 'file').toList();

    for (var field in textType) {
      textEditingControllerMap[field.fieldName] = TextEditingController();
    }

    // check if the field type is file
    fileType =
        await selectedDynamicList.where((e) => e.type == 'file').toList();
    // listing the all required file
    requiredFile =
        await fileType.where((e) => e.validation == 'required').toList();
    // add the required file name in a seperate list for validation
    for (var file in requiredFile) {
      requiredTypeFileList.add(file.fieldName);
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

  refreshDynamicData() {
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    requiredTypeFileList.clear();
    pickedFile = null;
    fileMap.clear();
  }
  //--------------------------------------------------//
}

class DynamicFieldModel {
  String name;
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic validation;
  DynamicFieldModel(
      {required this.name,
      this.fieldName,
      this.fieldLevel,
      this.type,
      this.validation});
}

class OtherGatewayCurrencyModel {
  String gatewayName;
  String currency;
  OtherGatewayCurrencyModel(
      {required this.gatewayName, required this.currency});
}
