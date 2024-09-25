import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class EditPostRepo {
  static Future<http.Response> getEditPost({required String id}) async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.editPostUrl + "?id=$id");
  }

  static Future<http.Response> updatePost(
      {required Iterable<http.MultipartFile>? fileList,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.updatePostUrl,
        fields: fields,
        fileList: fileList);
  }
}
