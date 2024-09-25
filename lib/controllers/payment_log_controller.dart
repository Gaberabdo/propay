import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/data/repositories/payment_log_repo.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/payment_log_model.dart' as p;
import '../data/source/check_status.dart';

class PaymentLogController extends GetxController {
  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController remarkEditingCtrlr = TextEditingController();
  TextEditingController dateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<p.Data> paymentLogList = [];
  String status = "";
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      _page += 1;
      await getPaymentLogList(
          page: _page,
          transaction_id: transactionIdEditingCtrlr.text,
          status: status,
          date: dateTimeEditingCtrlr.text,
          isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + _page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    paymentLogList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = isFromOnRefreshIndicator == true ? 0 : 1;
    update();
  }

  Future getPaymentLogList(
      {required int page,
      required String transaction_id,
      required String status,
      required String date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await PaymentLogRepo.getPaymentLog(
        page: page, transaction_id: transaction_id, status: status, date: date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['data'];
        if (fetchedData.isNotEmpty) {
          paymentLogList
              .addAll(p.PaymentLogModel.fromJson(data).message!.data!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================paymentLog list len: " +
                paymentLogList.length.toString());
          }
          update();
        } else {
          paymentLogList
              .addAll(p.PaymentLogModel.fromJson(data).message!.data!);
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: true");
          }

          update();
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      paymentLogList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPaymentLogList(page: _page, transaction_id: '', status: '', date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    paymentLogList.clear();
  }
}
