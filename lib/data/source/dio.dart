import 'package:dio/dio.dart';
import '../../utils/app_constants.dart';
import '../../utils/services/localstorage/hive.dart';
import '../../utils/services/localstorage/keys.dart';

class DioFinalHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: PHPENDPOINT.baseUrlPHP,
        receiveDataWhenStatusError: true,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${HiveHelp.read(Keys.token)}ا',
        },
      ),
    );
  }

  static Future<dynamic> postData({
    required String method,
    required dynamic data,
    String? token,
  }) async {
    dio.options.headers.addAll(
      {
        "Accept-Language": 'en',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${HiveHelp.read(Keys.token)}',
      },
    );

    return await dio.post(
      method,
      data: data,
    );
  }

  static Future<dynamic> getData({
    required String method,
    Map<String, dynamic>? data,
  }) async {
    dio.options.headers.addAll(
      {
        'Authorization': 'Bearer ${HiveHelp.read(Keys.token)}',
      },
    );
    return await dio.get(method, data: data);
  }

  static Future<dynamic> putData({
    required String method,
    required Map<String, dynamic> data,
  }) async {
    dio.options.headers.addAll({
      "Accept-Language": 'en',
      'Authorization': 'Bearer ${HiveHelp.read(Keys.token)}',
    });

    return await dio.put(
      method,
      data: data,
    );
  }

  static Future<dynamic> patchData({
    required String method,
    required Map<String, dynamic> data,
  }) async {
    dio.options.headers.addAll(
      {
        "Accept-Language": 'en',
        'Authorization': 'Bearer ${HiveHelp.read(Keys.token)}',
      },
    );
    return await dio.patch(
      method,
      data: data,
    );
  }

  static Future<dynamic> deleteData({
    required String method,
    Map<String, dynamic>? data,
  }) async {
    dio.options.headers.addAll(
      {
        'Authorization': 'Bearer ${HiveHelp.read(Keys.token)}',
      },
    );
    return await dio.delete(
      method,
      data: data,
    );
  }
}
