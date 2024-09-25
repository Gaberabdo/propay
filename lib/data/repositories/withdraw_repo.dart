import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class WithdrawRepo {
  static Future<http.Response> getPayouts() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.payoutUrl);
  }

  static Future<http.Response> getBankFromBank(
      {required String bankName}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.getBankFromBankUrl,
        fields: {
          "bankName": bankName,
        });
  }

  static Future<http.Response> getBankFromCurrency(
      {required String currencyCode}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.getBankFromCurrencyUrl,
        fields: {
          "currencyCode": currencyCode,
        });
  }

  static Future<http.Response> payoutSubmit(
      {required Iterable<MultipartFile>? fileList,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.payoutSubmitUrl,
        fields: fields,
        fileList: fileList);
  }

  static Future<http.Response> flutterwaveSubmit(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.flutterwaveSubmitUrl, fields: fields);
  }
  
  static Future<http.Response> paystackSubmit(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.paystackSubmitUrl, fields: fields);
  }
}
