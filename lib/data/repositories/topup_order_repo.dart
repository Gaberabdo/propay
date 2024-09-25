import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class TopupOrderRepo {
  static Future<http.Response> getTopupOrder(
      {required int page}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.topupOrderUrl +
            "?page=$page");
  }
}
