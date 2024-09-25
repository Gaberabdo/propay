import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class DepositRepo {
  static Future<http.Response> getPaymentGateways() async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.gatewaysUrl);
  }
}
