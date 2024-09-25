import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class IdPurchaseRepo {
  static Future<http.Response> getIdPurchase(
      {required int page,
      required String transactionId,
      required String date}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.idPurchaseUrl +
            "?page=$page&transaction_id=$transactionId&datetrx=$date");
  }
}
