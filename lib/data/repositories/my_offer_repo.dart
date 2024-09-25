import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class MyOfferRepo {
  static Future<http.Response> getMyOffer(
      {required int page,
      required String date}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.myOfferUrl +
            "?page=$page&datetrx=$date");
  }
  static Future<http.Response> getMyOfferDetails(
      {required String id}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.myOfferDetailsUrl +
            "?id=$id");
  }
}
