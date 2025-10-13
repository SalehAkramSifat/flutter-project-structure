import 'package:flutter_project_structure/core/binding/app_binding.dart';
import 'package:flutter_project_structure/core/theme/app_theme.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:flutter_project_structure/core/utils/app_sizes.dart';
import 'package:flutter_project_structure/route/app_routes.dart';
import 'package:get/get.dart';

class PlatformUtils {
  static bool get isIOS =>
      foundation.defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid =>
      foundation.defaultTargetPlatform == TargetPlatform.android;
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          initialRoute: AppRoute.init,
        //   initialRoute: AppRoute.siteGuidlinesScreen,
          getPages: AppRoute.routes,

          initialBinding: AppBinding(),
          themeMode: ThemeMode.light,
          theme: _getLightTheme(),
          darkTheme: _getDarkTheme(),
          defaultTransition: PlatformUtils.isIOS
              ? Transition.cupertino
              : Transition.fade,
          locale: Get.deviceLocale,
          builder: (context, child) => PlatformUtils.isIOS
              ? CupertinoTheme(data: const CupertinoThemeData(), child: child!)
              : child!,
        );
      },
    );
  }

  ThemeData _getLightTheme() {
    return PlatformUtils.isIOS
        ? AppThemes.lightTheme.copyWith(platform: TargetPlatform.iOS)
        : AppThemes.lightTheme;
  }

  ThemeData _getDarkTheme() {
    return PlatformUtils.isIOS
        ? AppThemes.darkTheme.copyWith(platform: TargetPlatform.iOS)
        : AppThemes.darkTheme;
  }
}