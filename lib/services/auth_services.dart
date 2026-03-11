import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:qr_app/core/routes.dart';
import 'package:qr_app/models/user_model.dart';
import 'package:qr_app/providers/auth_provider.dart';
import 'package:qr_app/utils/const.dart';

class AuthServices extends GetxService {
  final AuthProvider _authProvider = Get.put(AuthProvider());
  final _storage = FlutterSecureStorage();
  RxBool isLogin = false.obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<String?> get token => _storage.read(key: Const.tokenKey);

  Future<void> saveToken({
    required String token,
    required User userData,
  }) async {
    await _storage.write(key: Const.tokenKey, value: token);
    user.value = userData;
    isLogin(true);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: Const.tokenKey);
    user.value = null;
    isLogin(false);
  }

  Future<void> _init() async {
    final token = await this.token;
    if (token != null) {
      final res = await _authProvider.me();
      if (res.isOk) {
        user.value = User.fromJson(res.body);
        isLogin(true);
        Future.delayed(
          Duration(seconds: 2),
          () => Get.offAllNamed(AppRoutes.home),
        );
      } else {
        await deleteToken();
        Future.delayed(
          Duration(seconds: 2),
          () => Get.offAllNamed(AppRoutes.login),
        );
      }
    } else {
      Future.delayed(
        Duration(seconds: 2),
        () => Get.offAllNamed(AppRoutes.login),
      );
    }
  }

  Future<void> logout() async {
    await _authProvider.logout();
    await deleteToken();
    Get.offAllNamed(AppRoutes.login);
  }
}


// lanjut video ke 3 awal