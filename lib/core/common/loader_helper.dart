import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoaderHelper {
  static Future<T> showLoader<T>(
    Future<T> Function() action, {
    Widget? loadingWidget,
    bool barrierDismissible = false,
  }) async {
    try {
      if (!(Get.isDialogOpen ?? false)) {
        Get.dialog(
          loadingWidget ??
              Center(child: SpinKitCircle(color: Colors.blue)),
          barrierDismissible: barrierDismissible,
        );
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // Run the actual Future / API call
      return await action();
    } catch (e) {
      rethrow; // let caller handle error
    } finally {
      // Close loader if open
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }
}