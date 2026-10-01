import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/no_internet_screen.dart';
import 'package:flutter_project_structure/core/services/network_controller.dart';
import 'package:get/get.dart';

/// A global wrapper widget that wraps the application.
///
/// Behavior:
/// 1. If the app opens with no internet, [NoInternetScreen] is displayed immediately.
/// 2. If the internet drops while using the app, [NoInternetScreen] overlays the current screen
///    without destroying or popping underlying state (form inputs & routes remain intact).
/// 3. As soon as the internet connection is restored, [NoInternetScreen] automatically disappears.
class NetworkWrapper extends StatelessWidget {
  final Widget child;

  const NetworkWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<NetworkController>()
        ? Get.find<NetworkController>()
        : Get.put(NetworkController(), permanent: true);

    return Obx(() {
      final isConnected = controller.isConnected.value;

      if (!isConnected) {
        FocusManager.instance.primaryFocus?.unfocus();
      }

      return Stack(
        children: [
          child,
          if (!isConnected)
            Positioned.fill(
              child: PopScope(
                canPop: false,
                child: Material(
                  color: Colors.white,
                  child: NoInternetScreen(
                    isFullScreen: true,
                    isRetrying: controller.isChecking.value,
                    onRetry: () => controller.checkConnection(),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
