import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/repositories/addFund_repo.dart';
import '../data/source/check_status.dart';
import '../routes/page_index.dart';
import '../utils/services/helpers.dart';

class AddFundController extends GetxController {
  static AddFundController get to => Get.find<AddFundController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController amountCtrl = TextEditingController();

  Future getPaymentGateways() async {
    _isLoading = true;
    update();
    http.Response response = await DepositRepo.getPaymentGateways();
    _isLoading = false;
    update();

  }

  @override
  void onInit() {
    super.onInit();
    getPaymentGateways();
  }
}
