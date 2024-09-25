import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class BuyIdRepo {
  static Future<http.Response> getBuyIdList({
    required int page,
    String? sortBy,
    String? sortByCategory,
    String? minPrice,
    String? maxPrice,
  }) async {
    if (sortBy != null) {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.buyIdUrl + "?page=$page&sortBy=$sortBy");
    } else if (minPrice != null && maxPrice != null && sortByCategory == null) {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.buyIdUrl +
              "?page=$page&minPrice=$minPrice&maxPrice=$maxPrice");
    } else if (sortByCategory != null && minPrice == null && maxPrice == null) {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.buyIdUrl +
              "?page=$page&sortByCategory=$sortByCategory");
    } else if (minPrice != null && maxPrice != null && sortByCategory != null) {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.buyIdUrl +
              "?page=$page&sortByCategory=$sortByCategory&minPrice=$minPrice&maxPrice=$maxPrice");
    } else {
      return await ApiClient.get(
          ENDPOINT_URL: AppConstants.buyIdUrl + "?page=$page");
    }
  }

  static Future<http.Response> makeOffer(
      {required Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.makeOfferUrl, fields: fields);
  }

  static Future<http.Response> buyIdMakePayment(
      {required Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.buyIdMakePayment, fields: fields);
  }
}
