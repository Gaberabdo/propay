import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class TransactionRepo {
  static Future<http.Response> getTransactionList(
      {required int page,
      required String transaction_id,
      required String remark,
      required String date}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.transactionUrl +
            "?page=$page&transaction_id=$transaction_id&remark=$remark&datetrx=$date");
  }
}
