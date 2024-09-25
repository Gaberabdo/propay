import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/voucher_order_model.dart' as v;
import '../data/repositories/voucher_order_repo.dart';
import '../data/source/check_status.dart';

class VoucherOrderController extends GetxController {
  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController dateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<v.Datum> voucherOrderList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      _page += 1;
      await getVoucherOrderList(
          page: _page,
          transaction_id: transactionIdEditingCtrlr.text,
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
    voucherOrderList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = isFromOnRefreshIndicator == true ? 0 : 1;
    update();
  }

  Future getVoucherOrderList(
      {required int page,
      required String transaction_id,
      required String date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await VoucherOrderRepo.getVoucherOrder(
        page: page, transactionId: transaction_id, date: date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['data'];
        if (fetchedData.isNotEmpty) {
          voucherOrderList
              .addAll(v.VoucherOrderModel.fromJson(data).message!.data!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================paymentLog list len: " +
                voucherOrderList.length.toString());
          }
          update();
        } else {
          voucherOrderList
              .addAll(v.VoucherOrderModel.fromJson(data).message!.data!);
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
      voucherOrderList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getVoucherOrderList(page: _page, transaction_id: '', date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    voucherOrderList.clear();
  }
}
