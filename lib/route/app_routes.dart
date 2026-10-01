import 'package:flutter_project_structure/core/common/no_internet_screen.dart';
import 'package:flutter_project_structure/feature/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  static String init = "/init";
  static String noInternet = "/no-internet";

  static List<GetPage> routes = [
    GetPage(name: init, page: () => const SplashScreen()),
    GetPage(name: noInternet, page: () => const NoInternetScreen()),
  ];
}
