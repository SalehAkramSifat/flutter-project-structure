import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
  }

  @override
  void onInit() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    themeMode.value = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    super.onInit();
  }
}