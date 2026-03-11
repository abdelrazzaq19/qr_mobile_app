import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/core/routes.dart';
import 'package:qr_app/models/user_model.dart';
import 'package:qr_app/providers/auth_provider.dart';
import 'package:qr_app/services/auth_services.dart';
import 'package:qr_app/utils/show_snack.dart';

class AuthController extends GetxController {
  final AuthProvider _auth = Get.find<AuthProvider>();
  final AuthServices _authServices = Get.find<AuthServices>();

  RxBool isLoading = false.obs;

  RxBool isObscure = true.obs;
  RxBool isObscureConfirm = true.obs;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void toggleObscureConfirm() {
    isObscureConfirm.value = !isObscureConfirm.value;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoading(true);
    try {
      final res = await _auth.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      if (res.isOk) {
        await _authServices.saveToken(
          token: res.body['data']['token'],
          userData: User.fromJson(res.body['data']['user']),
        );
        Get.offAllNamed(AppRoutes.home);
      } else {
        throw res.body['message'];
      }
    } catch (e) {
      ShowSnack.error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;
    isLoading(true);
    try {
      final res = await _auth.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );
      if (res.isOk) {
        await _authServices.saveToken(
          token: res.body['data']['token'],
          userData: User.fromJson(res.body['data']['user']),
        );
        Get.offAllNamed(AppRoutes.home);
      } else {
        final errors = res.body['errors'];
        if (errors is! Map) {
          throw res.body['message'];
        } else {
          throw errors.values.first[0];
        }
      }
    } catch (e) {
      ShowSnack.error(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
