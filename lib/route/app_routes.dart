import 'package:flutter_project_structure/feature/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  static String init = "/init";

  static List<GetPage> routes = [
    GetPage(name: init, page: () => SplashScreen()),
  ];
}
