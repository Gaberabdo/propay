import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/data/source/dio.dart';
import 'package:gamers_arena/utils/app_constants.dart';
import 'package:gamers_arena/utils/services/localstorage/keys.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;

import '../data/models/giftCard_details_model.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/hive.dart';

class MyOfferController extends GetxController {
  TextEditingController playerId = TextEditingController();
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool isLoading = false;
  bool isLoadingOrder = false;

  List<SubCatItem> serviceDetails = [];
  void getMyOfferList(id) async {
    isLoading = true;
    update();
    try {
      var data = await DioFinalHelper.postData(
        method: PHPENDPOINT.subcat_content,
        data: {"user_id": HiveHelp.read(Keys.uid), "subcat_id": id},
      );

      var decode = jsonDecode(data.data);

      serviceDetails = (decode['data'] as List)
          .map((gameJson) => SubCatItem.fromJson(gameJson))
          .toList();

      isLoading = false;
      print(data.data);
      update();
    } on DioException catch (e) {
      isLoading = false;
      print(e.message);
      Helpers.showSnackBar(msg: e.message!);
      update();
    }
  }

  Future CreateMyOffer({
    required String MENA,
    required String bill,
    required String type,
    required String subcat_id,
  }) async {
    isLoadingOrder = true;
    update();
    try {
      var data = await DioFinalHelper.postData(
        method: PHPENDPOINT.create_my_offer,
        data: {
          "player_number": playerId.text,
          "MENA": MENA,
          "bill": bill,
          "type": type,
          "subcat_id": subcat_id,
          "user_id": HiveHelp.read(Keys.uid),
        },
      );

      var decode = jsonDecode(data.data);
      Helpers.showSnackBar(msg: decode['msg']);


      isLoadingOrder = false;
      print(data.data);
      playerId.clear();
      update();
    } on DioException catch (e) {
      isLoadingOrder = false;
      print(e.message);
      var decode = jsonDecode(e.response!.data);

      Helpers.showSnackBar(msg:decode['msg']);
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    playerId.dispose();
    serviceDetails.clear();
  }
}
