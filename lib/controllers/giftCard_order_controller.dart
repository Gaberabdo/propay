import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamers_arena/data/repositories/gift_card_repo.dart';
import 'package:gamers_arena/data/source/dio.dart';
import 'package:gamers_arena/utils/services/localstorage/hive.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/giftCard_details_model.dart';
import '../data/models/giftCard_order_model.dart' as g;
import '../data/models/giftCard_order_model.dart';
import '../data/source/check_status.dart';
import '../utils/app_constants.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/keys.dart';

class GiftCardOrderController extends GetxController {
  TextEditingController searchController = TextEditingController();
  bool isLoadMore = false;
  bool isLoading = false;

  bool isSearchTapped = false;

  GiftCardOrderController(this.filterName);
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {}

  List<Game> gamesModel = [];
  Future getServicesByCategory() async {
    isLoading = true;
    update();
    try {
      var response = await DioFinalHelper.getData(
        method: PHPENDPOINT.allCate,
      );
      var decode = jsonDecode(response.data);

      List<Game> games = (decode['data'] as List)
          .map((gameJson) => Game.fromJson(gameJson))
          .toList();

      List<Game> filteredGames = filterByCategory(games);
      gamesModel = filteredGames;
      isLoading = false;
      update();
    } on DioException catch (e) {
      isLoading = false;

      update();
      Helpers.showSnackBar(msg: e.message!);
    }
  }

  List<SubCat> category = [];
  Future getServicesBySubCategory(cat_id) async {
    isLoading = true;
    try {
      var response = await DioFinalHelper.postData(
        method: PHPENDPOINT.allSubCate,
        data: {
          "user_id": HiveHelp.read(Keys.uid),
          "cat_id": cat_id,
        },
      );
      var decode = jsonDecode(response.data);

      category = (decode['data'] as List)
          .map((gameJson) => SubCat.fromJson(gameJson))
          .toList();

      isLoading = false;
      update();
    } on DioException catch (e) {
      isLoading = false;
      print(e.message);
      update();
      Helpers.showSnackBar(msg: e.message!);
    }
  }

  String cid = "";
  void changeCValue(String id) {
    cid = id;
  }

  List<SubCatItem> serviceDetails = [];
  void getMyOfferList(id) async {
    isLoading = true;
    try {
      var data = await DioFinalHelper.postData(
        method: PHPENDPOINT.subcat_content,
        data: {
          "user_id": HiveHelp.read(Keys.uid),
          "subcat_id": id,
        },
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

  List<Game> originalGames = []; // Store the original list
  List<Game> filteredGames = []; // Store the filtered list

  Future<void> search(String name) async {
    isSearchTapped = true;

    // Check if originalGames is empty, meaning it's the first search
    if (originalGames.isEmpty) {
      // Clone the original games list for the first time
      originalGames = List.from(gamesModel);
    }

    // Now filter based on the original list
    filteredGames = originalGames.where((element) {
      return element.name != null && element.name!.contains(name);
    }).toList();

    // If no match found, handle empty result accordingly
    if (filteredGames.isEmpty) {
      // Optionally display a "No results found" message
      print('No results found');
    } else {
      // Update the UI or list with the filtered games
      gamesModel = filteredGames;
    }

    update(); // Update the state/UI
  }

  String filterName;

  List<Game> filterByCategory(List<Game> games) {
    switch (filterName) {
      case 'ADSL':
        return games.where((game) => game.aDSL == '1').toList();
      case 'Games':
        return games.where((game) => game.name!.contains('شحن')).toList();
      case 'Traffic Violations':
        return games
            .where(
                (game) => game.name != null && game.name!.contains('Traffic'))
            .toList();
      case 'Authority':
        return games
            .where((game) => game.name == 'Syria Tel' || game.name == 'MTN')
            .toList();
      case 'Water Bills':
        return games
            .where((game) => game.name != null && game.name!.contains('المياه'))
            .toList();
      case 'services':
        return games
            .where((game) =>
                game.name!.contains('المياه') ||
                game.name!.contains('Traffic') ||
                game.name!.contains('هاتف أرضي') ||
                game.name!.contains('الكهرباء'))
            .toList();
      default:
        return games;
    }
  }

  Future cancelSearch() async {
    isSearchTapped = false;

    searchController.clear();
    getServicesByCategory();
  }

  var codeController = TextEditingController();
  var amountController = TextEditingController();
  var numberController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  Future CreateMyOffer({
    required String subcat_id,
  }) async {
    try {
      var data = await DioFinalHelper.postData(
        method: PHPENDPOINT.create_my_offer,
        data: (serviceDetails.first.data != null)
            ? {
                "DistributorCode": codeController.text,
                "nambr": numberController.text,
                "bill": amountController.text,
                "CYTI": "[ $cid, 0 ]",
                "type": 1,
                "subcat_id": subcat_id,
                "user_id": HiveHelp.read(Keys.uid),
              }
            : {
                "nambar": numberController.text,
                "bill": amountController.text,
                "type": 1,
                "subcat_id": subcat_id,
                "user_id": HiveHelp.read(Keys.uid),
              },
      );

      var decode = jsonDecode(data.data);
      Helpers.showSnackBar(msg: decode['msg']);
    } on DioException catch (e) {
      print(e.message);
      var decode = jsonDecode(e.response!.data);

      Helpers.showSnackBar(msg: decode['msg']);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
    amountController.dispose();
    numberController.dispose();
    gamesModel.clear();
  }
}
