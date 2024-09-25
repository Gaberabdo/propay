import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class CreatePostRepo {
  static Future<http.Response> getSellPostCategory() async {
    return await ApiClient.get(
        ENDPOINT_URL:
            AppConstants.sellPostCategoryUrl);
  }
  
  static Future<http.Response> getSellPostCategoryById(
      {required String category_id}) async {
    return await ApiClient.get(
        ENDPOINT_URL:
            AppConstants.sellPostCategoryUrl + "?category_id=$category_id");
  }
  
  static Future<http.Response> createPost(
      {required Iterable<http.MultipartFile>? fileList,
      required Map<String, String> fields}) async {
    return await ApiClient.postMultipart(
        ENDPOINT_URL: AppConstants.createPostUrl,
        fields: fields,
        fileList: fileList);
  }
}
