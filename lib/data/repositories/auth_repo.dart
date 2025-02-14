import 'package:gamers_arena/data/source/api_client.dart';
import 'package:gamers_arena/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  static Future<http.Response> register(
      {required Map<String, dynamic> data}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.registerUrl, fields: data);
  }

  static Future<http.Response> login(
      {required Map<String, dynamic> data}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.loginUrl, fields: data);
  }

  static Future<http.Response> forgotPass(
      {required Map<String, dynamic> data}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.forgotPassUrl, fields: data);
  }
  static Future<http.Response> getCode(
      {required Map<String, dynamic> data}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.forgotPassGetCodeUrl, fields: data);
  }
  static Future<http.Response> updatePass(
      {required Map<String, dynamic> data}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.updatePassUrl, fields: data);
  }
}
