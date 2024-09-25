import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class GiftCardOrderRepo {
  static Future<http.Response> getGiftCardOrder(
      {required int page,
      required String transactionId,
      required String date}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.giftCardOrderUrl +
            "?page=$page&transaction_id=$transactionId&datetrx=$date");
  }
}
