import 'package:get/get.dart';
import 'package:qr_app/bindings/auth_binding.dart';
import 'package:qr_app/pages/home_page.dart';
import 'package:qr_app/pages/login_page.dart';
import 'package:qr_app/pages/register_page.dart';
import 'package:qr_app/pages/splash_page.dart';

class AppRoutes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";

  static const String initialRoute = splash;

  static List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashPage()),
    GetPage(name: login, page: () => LoginPage(), binding: AuthBinding()),
    GetPage(name: register, page: () => RegisterPage(), binding: AuthBinding()),
    GetPage(name: home, page: () => HomePage()),
  ];
}
