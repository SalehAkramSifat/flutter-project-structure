import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_appbar.dart';
import 'package:flutter_project_structure/core/common/custom_submit_button.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter_project_structure/core/common/no_internet_screen.dart';
import 'package:flutter_project_structure/core/services/network_controller.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppbar(
        title: 'Project Dashboard',
        showBackIcon: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Real-time Status Card
              Obx(() {
                final isOnline = networkController.isConnected.value;

                return Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isOnline
                          ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
                          : AppColors.error.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                        size: 48.sp,
                        color: isOnline
                            ? const Color(0xFF4CAF50)
                            : AppColors.error,
                      ),
                      SizedBox(height: 12.h),
                      CustomText(
                        text: isOnline
                            ? 'Internet Connected (Online)'
                            : 'No Internet Connection (Offline)',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isOnline
                            ? const Color(0xFF2E7D32)
                            : AppColors.error,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: isOnline
                            ? 'Real-time connectivity is active. If your connection drops, the NoInternetScreen animation will automatically cover this view.'
                            : 'Connection is offline. The automatic overlay is active.',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                        height: 1.4,
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 32.h),

              // Test Section Header
              CustomText(
                text: 'Testing Controls',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text:
                    'Use the buttons below or simply toggle Wi-Fi / Airplane mode from your phone status bar to test.',
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),

              SizedBox(height: 20.h),

              // Button 1: Simulate Disconnect
              CustomSubmitButton(
                text: '🔌 Simulate Disconnect',
                color: AppColors.error,
                onTap: () {
                  // Simulate offline state
                  networkController.isConnected.value = false;
                },
              ),

              SizedBox(height: 14.h),

              // Button 2: Open NoInternetScreen Directly
              CustomSubmitButton(
                text: '👁️ Preview Screen Directly (Route)',
                color: AppColors.primary,
                onTap: () {
                  Get.to(
                    () => NoInternetScreen(
                      showBackButton: true,
                      onRetry: () => Get.back(),
                    ),
                  );
                },
              ),

              SizedBox(height: 24.h),

              // Information Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.textFormFieldBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomText(
                        text:
                            'How it works: NetworkWrapper in lib/app.dart wraps your entire application. When internet is lost, NoInternetScreen appears seamlessly. When internet restores (or you click Try Again), it disappears automatically.',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
