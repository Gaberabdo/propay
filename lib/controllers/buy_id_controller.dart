import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/models/buy_id_model.dart' as b;
import 'package:http/http.dart' as http;
import '../data/repositories/buy_id_repo.dart';
import '../data/repositories/my_offer_repo.dart';
import '../data/source/check_status.dart';
import '../routes/page_index.dart';
import '../utils/services/helpers.dart';
import 'create_post_controller.dart';

class BuyIdController extends GetxController {
  static BuyIdController get to => Get.find<BuyIdController>();

  //-------------------------
  double val = 0.0;
  List<bool> checkBoxValList = [];
  dynamic groupVal = 0;
  List<int> selectedCategoryList = [];

  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  late ScrollController scrollController;

  List<b.Data> buyIdList = [];
  List<b.Data> searchedbuyIdList = [];
  List<DynamicCategoryField> dynamicPostSpecificationList = [];
  dynamic minPrice = null;
  dynamic maxPrice = null;
  dynamic sortBy = null;
  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    buyIdList.clear();
    titleEditingCtrlr.clear();
    buyIdList.clear();
    searchedbuyIdList.clear();
    dynamicPostSpecificationList.clear();
    isSearching = false;
    isSearchTapped = true;
    groupVal = 0;
    val = 0.0;
    hasNextPage = true;
    page = 1;
    Helpers.hideKeyboard();
    update();
  }

  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getBuyIdList(
        page: page,
        sortBy: sortBy,
        sortByCategory: selectedCategoryList.isEmpty
            ? null
            : selectedCategoryList.join(','),
        minPrice: minPrice,
        maxPrice: maxPrice,
        isLoadMoreRunning: true,
      );
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  dynamic my_id = 0;
  Future getBuyIdList({
    required int page,
    String? sortByCategory,
    String? minPrice,
    String? maxPrice,
    String? sortBy,
    bool? isLoadMoreRunning = false,
  }) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await BuyIdRepo.getBuyIdList(
      page: page,
      sortBy: sortBy,
      sortByCategory: sortByCategory,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['sellPost']['data'];
        if (fetchedData.isNotEmpty) {
          buyIdList
              .addAll(b.BuyIdModel.fromJson(data).message!.sellPost!.data!);
          this.my_id = data['message']['my_id'];
          for (var sellPost in data['message']['sellPost']['data']) {
            if (sellPost['post_specification_form'] != null &&
                sellPost['post_specification_form'] is Map) {
              Map<String, dynamic> postSpecification =
                  sellPost['post_specification_form'];
              postSpecification.forEach((key, value) {
                dynamicPostSpecificationList.add(DynamicCategoryField(
                  id: sellPost['id'].toString(),
                  fieldName: value['field_name'],
                  fieldValue: value['field_value'],
                  type: value['type'],
                  validation: value['validation'],
                ));
              });
            }
          }
          update();
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          debugPrint("================isDataEmpty: false");
          debugPrint(
              "================idBuyList len: " + buyIdList.length.toString());
          update();
        } else {
          buyIdList
              .addAll(b.BuyIdModel.fromJson(data).message!.sellPost!.data!);
          this.my_id = data['message']['my_id'];
          for (var sellPost in data['message']['sellPost']['data']) {
            if (sellPost['post_specification_form'] != null &&
                sellPost['post_specification_form'] is Map) {
              Map<String, dynamic> postSpecification =
                  sellPost['post_specification_form'];
              postSpecification.forEach((key, value) {
                dynamicPostSpecificationList.add(DynamicCategoryField(
                  id: sellPost['id'].toString(),
                  fieldName: value['field_name'],
                  fieldValue: value['field_value'],
                  type: value['type'],
                  validation: value['validation'],
                ));
              });
            }
          }
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          debugPrint("================isDataEmpty: true");

          update();
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
        buyIdList = [];
        update();
      }
    } else {
      Helpers.showSnackBar(msg: response.body);
      buyIdList = [];
      update();
    }
  }

  bool isSearching = false;
  TextEditingController titleEditingCtrlr = TextEditingController();
  querytitle(String v) {
    searchedbuyIdList = buyIdList
        .where(
            (e) => e.title.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    if (v.isEmpty) {
      isSearching = false;
      searchedbuyIdList.clear();
      update();
    } else if (v.isNotEmpty) {
      isSearching = true;
      update();
    }
    update();
  }

  Future getMyOfferDetails({
    required String id,
  }) async {
    _isLoading = true;
    update();
    http.Response response = await MyOfferRepo.getMyOfferDetails(id: id);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
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

  TextEditingController amountCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  bool isOffering = false;
  Future makeOffer(
      {required Map<String, dynamic> fields,
      required BuildContext context}) async {
    isOffering = true;
    update();
    http.Response response = await BuyIdRepo.makeOffer(fields: fields);
    isOffering = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        amountCtrl.clear();
        descriptionCtrl.clear();
        Navigator.of(context).pop();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data}');
    }
  }

  Future buyIdMakePayment(
      {required Map<String, dynamic> fields,
      required BuildContext context}) async {

  }

  @override
  void onInit() {
    super.onInit();
    getBuyIdList(page: page);
    CreatePostController.to.getSellsCategory();
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    buyIdList.clear();
  }
}

class DynamicCategoryField {
  dynamic id;
  dynamic fieldName;
  dynamic fieldValue;
  dynamic type;
  dynamic validation;
  DynamicCategoryField(
      {required this.id,
      this.fieldName,
      this.fieldValue,
      this.type,
      this.validation});
}
