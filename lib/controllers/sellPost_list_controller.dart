import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/sellPost_list_model.dart' as sell;
import '../data/repositories/sellpost_list_repo.dart';
import '../data/source/check_status.dart';

class SellPostListController extends GetxController {
  static SellPostListController get to => Get.find<SellPostListController>();
  TextEditingController titleEditingCtrlr = TextEditingController();
  TextEditingController dateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<sell.Data> sellPostList = [];
  List<sell.Data> searchedSellPostList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      _page += 1;
      await getIdPurchaseList(
          page: _page,
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
    sellPostList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    _page = 1;
    update();
  }

  Future getIdPurchaseList(
      {required int page,
      required String date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response =
        await SellPostListRepo.getSellPostList(page: page, date: date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['data'];
        if (fetchedData.isNotEmpty) {
          sellPostList
              .addAll(sell.SellpostListModel.fromJson(data).message!.data!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================sellPost list len: " +
                sellPostList.length.toString());
          }
          update();
        } else {
          sellPostList
              .addAll(sell.SellpostListModel.fromJson(data).message!.data!);
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
      sellPostList = [];
    }
  }

  Future deleteSellPostList({required String id}) async {
    http.Response response = await SellPostListRepo.deleteSellPostList(id: id);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        resetDataAfterSearching();
        getIdPurchaseList(date: "", page: 1);
      }
    } else {
      sellPostList = [];
    }
  }

  bool isSearching = false;
  querytitle(String v) {
    searchedSellPostList = sellPostList
        .where(
            (e) => e.title.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    if (v.isEmpty) {
      isSearching = false;
      searchedSellPostList.clear();
      update();
    } else if (v.isNotEmpty) {
      isSearching = true;
      update();
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getIdPurchaseList(page: _page, date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    sellPostList.clear();
  }
}
