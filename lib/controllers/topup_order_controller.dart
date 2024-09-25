import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/topup_order_model.dart' as t;
import '../data/repositories/topup_order_repo.dart';
import '../data/source/check_status.dart';

class TopupOrderController extends GetxController {
  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController remarkEditingCtrlr = TextEditingController();
  TextEditingController dateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<t.Data> topupOrderList = [];
  String status = "";
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      _page += 1;
      await getTopupOrderList(page: _page, isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + _page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    topupOrderList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = isFromOnRefreshIndicator == true ? 0 : 1;
    dateTimeEditingCtrlr.clear();
    transactionIdEditingCtrlr.clear();
    remarkEditingCtrlr.clear();
    update();
  }

  Future getTopupOrderList(
      {required int page, bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await TopupOrderRepo.getTopupOrder(page: page);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['data'];
        if (fetchedData.isNotEmpty) {
          topupOrderList
              .addAll(t.TopupOrderModel.fromJson(data).message!.data!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================paymentLog list len: " +
                topupOrderList.length.toString());
          }
          update();
        } else {
          topupOrderList
              .addAll(t.TopupOrderModel.fromJson(data).message!.data!);
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
      topupOrderList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getTopupOrderList(page: _page);
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    topupOrderList.clear();
  }
}
