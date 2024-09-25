import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class SellPostListRepo {
  static Future<http.Response> getSellPostList(
      {required int page,
      required String date}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.sellPostListUrl +
            "?page=$page&datetrx=$date");
  }
  
  static Future<http.Response> deleteSellPostList(
      {required String id}) async {
    return await ApiClient.delete(
        ENDPOINT_URL: AppConstants.sellPostDeleteUrl +
            "?id=$id");
  }
}
