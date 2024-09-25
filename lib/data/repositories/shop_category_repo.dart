import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class ShopCategoryRepo {
  static Future<http.Response> getShopList(
      {required int page,
      required String sortByCategory,
      required String sortBy}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.shopListUrl +
            "?page=$page&sortByCategory=$sortByCategory&sortBy=$sortBy");
  }

  static Future<http.Response> getTopupDetails({required int id}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.topupDetailsUrl + "?id=$id");
  }

  static Future<http.Response> getVoucherDetails({required int id}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.voucherDetailsUrl + "?id=$id");
  }

  static Future<http.Response> getGiftCardDetails({required int id}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.giftCardDetailsUrl + "?id=$id");
  }

  static Future<http.Response> topupPayment(
      {Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.topupPaymentUrl, fields: fields);
  }

  static Future<http.Response> voucherPayment(
      {Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.voucherPaymentUrl, fields: fields);
  }

  static Future<http.Response> giftCardPayment(
      {Map<String, dynamic>? fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.giftCardPaymentUrl, fields: fields);
  }

  static Future<http.Response> manualPayment(
      {required Iterable<http.MultipartFile>? fileList,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.manualPaymentUrl,
        fields: fields,
        fileList: fileList);
  }
  
  static Future<http.Response> otherPayment(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.otherPaymentUrl,
        fields: fields);
  }

  static Future<http.Response> walletPayment(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.walletPaymentUrl,
        fields: fields);
  }

  static Future<http.Response> cardPayment(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.cardPaymentUrl,
        fields: fields);
  }

  static Future<http.Response> onPaymentDone(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.onPaymentDoneUrl,
        fields: fields);
  }
}
