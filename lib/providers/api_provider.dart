import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:qr_app/env/env.dart';
import 'package:qr_app/utils/const.dart';

class ApiProvider extends GetConnect {
  final storage = FlutterSecureStorage();

  @override
  void onInit() {
    httpClient.baseUrl = Const.baseApiUrl;
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = await storage.read(key: Const.tokenKey);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['X-API-Key'] = Env.apiKey;
      return request;
    });
    super.onInit();
  }
}
