import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class PaymentLogRepo {
  static Future<http.Response> getPaymentLog(
      {required int page,
      required String transaction_id,
      required String status,
      required String date}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.paymentLogUrl +
            "?page=$page&name=$transaction_id&date_time=$date&status=$status");
  }
}
