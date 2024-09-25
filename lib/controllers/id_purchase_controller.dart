import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/data/repositories/id_purchase_repo.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/id_purchase_model.dart' as i;
import '../data/source/check_status.dart';

class IdPurchaseController extends GetxController {
  TextEditingController titleEditingCtrlr = TextEditingController();
  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController dateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int _page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<i.Data> idPurchaseList = [];
  List<i.Data> searchedPurchaseList = [];
  List<MoreInformation> dynamicFormList = [];
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
    idPurchaseList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    // _page = isFromOnRefreshIndicator == true ? 0 : 1;
    _page = 1;
    update();
  }

  Future getIdPurchaseList(
      {required int page,
      required String transaction_id,
      required String date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await IdPurchaseRepo.getIdPurchase(
        page: page, transactionId: transaction_id, date: date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['data'];
        for (var i in fetchedData) {
          if (i['moreInformation'] is Map && i['moreInformation'] != null) {
            // dynamic field
            Map<String, dynamic> dForm = i['moreInformation'];
            List<IdPurchaseDynamicFormModel> formList = [];

            dForm.forEach((key, value) {
              formList.add(
                IdPurchaseDynamicFormModel(
                  fieldName: value['field_name'],
                  fieldValue: value['field_value'],
                  type: value['type'],
                  validation: value['validation'],
                ),
              );
            });

            // Add the MoreInformation instance to the list
            dynamicFormList.add(
              MoreInformation(
                title: i['title'],
                form: formList,
              ),
            );
          }
        }
        if (fetchedData.isNotEmpty) {
          idPurchaseList
              .addAll(i.IdPurchaseModel.fromJson(data).message!.data!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: false");
            print("================idPurchase list len: " +
                idPurchaseList.length.toString());
          }
          update();
        } else {
          idPurchaseList
              .addAll(i.IdPurchaseModel.fromJson(data).message!.data!);
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
      idPurchaseList = [];
    }
  }

  bool isSearching = false;
  List<MoreInformation> searchedDynamicFormList = [];
  querytitle(String v) {
    searchedPurchaseList = idPurchaseList
        .where(
            (e) => e.title.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    for (var i in searchedPurchaseList) {
      searchedDynamicFormList =
          dynamicFormList.where((e) => e.title == i.title).toList();
    }
    if (v.isEmpty) {
      isSearching = false;
      searchedDynamicFormList.clear();
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
    getIdPurchaseList(page: _page, transaction_id: '', date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    idPurchaseList.clear();
  }
}

class MoreInformation {
  final String title;
  final List<IdPurchaseDynamicFormModel> form;
  MoreInformation({required this.title, required this.form});
}

class IdPurchaseDynamicFormModel {
  String fieldName;
  String fieldValue;
  String type;
  String validation;

  IdPurchaseDynamicFormModel({
    required this.fieldName,
    required this.fieldValue,
    required this.type,
    required this.validation,
  });
}
