import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/data/source/dio.dart';
import 'package:gamers_arena/utils/app_constants.dart';
import 'package:get/get.dart';
import '../data/models/transaction_model.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';

class TransactionController extends GetxController {
  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController remarkEditingCtrlr = TextEditingController();
  TextEditingController dateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  bool isLoading = false;

  List<Transaction> transactionList = [];
  List<Transaction> filteredCenterModels = [];


  void filterCenterModels(String query) {
      filteredCenterModels = transactionList.where((Transaction) =>
      Transaction.name.toLowerCase().contains(query.toLowerCase()) ||
          Transaction.arabicName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      update();
  }
  bool isSearchTapped = false;

  Future getTransactionList() async {
    isLoading = true;
    update();
    try {
      final response = await DioFinalHelper.postData(
        method: PHPENDPOINT.userTransactionEndPoint,
        data: {
          "user_id": HiveHelp.read(Keys.uid),
        }
      );

      Map decode = jsonDecode(response.data);
      transactionList = (decode['data'] as List).map((e) => Transaction.fromJson(e)).toList();
      filteredCenterModels = transactionList;
      isLoading = false;
      update();
    } on DioException catch (e) {
      isLoading = false;
      print(e.response);
      update();
    }
  }

  @override
  void onInit() async {

    print('**********************');

    await getTransactionList();

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    transactionList.clear();
  }
}
