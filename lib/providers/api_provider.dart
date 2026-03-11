import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
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
      return request;
    });
    super.onInit();
  }
}
// video ke 2 44m 11d