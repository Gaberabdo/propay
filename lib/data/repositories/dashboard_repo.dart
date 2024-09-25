import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../source/api_client.dart';

class DashboardRepo {
  static Future<http.Response> getDashboardData() async {
    return await ApiClient.get(
        ENDPOINT_URL: AppConstants.dashboardUrl);
  }
}
