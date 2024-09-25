import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class ConversationRepo {
  static Future<http.Response> getConversationList({
    required int page,
    required String dateTime,
    required String sortBy,
  }) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.offerListUrl +
            "?page=$page&datetrx=$dateTime&sortBy=$sortBy");
  }

  static Future<http.Response> getConversation({required String uuid}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.conversationUrl + "?uuid=$uuid");
  }

  static Future<http.Response> createNewMessage(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.newMessageUrl, fields: fields);
  }
  
  static Future<http.Response> offerLock(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.offerLockUrl, fields: fields);
  }
  static Future<http.Response> offerAccept(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.offerAcceptUrl, fields: fields);
  }
  static Future<http.Response> offerReject(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.offerRejectUrl, fields: fields);
  }
  static Future<http.Response> offerRemove(
      {required Map<String, String> fields}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.offerRemoveUrl, fields: fields);
  }
}
