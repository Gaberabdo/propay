import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class ProfileRepo {

  static Future<http.Response> getProfile() async {
    return await ApiClient.get(ENDPOINT_URL: AppConstants.profileUrl);
  }

  static Future<http.Response> profileUpdate(
      {required Map<String, dynamic> data}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.profileUpdateUrl, fields: data);
  }
  static Future<http.Response> profilePassUpdate(
      {required Map<String, dynamic> data}) async {
    return await ApiClient.post(
        ENDPOINT_URL: AppConstants.profilePassUpdateUrl, fields: data);
  }

  static Future<http.Response> profileImageUpload(
      {required MultipartFile files}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.profileImageUploadUrl, files: files);
  }
}
