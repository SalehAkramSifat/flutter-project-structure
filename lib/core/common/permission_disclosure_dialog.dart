import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:get/get.dart';

enum PermissionType { location, camera, storage }

class PermissionDisclosureDialog extends StatelessWidget {
  final PermissionType permissionType;
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const PermissionDisclosureDialog({
    super.key,
    required this.permissionType,
    required this.title,
    required this.description,
    required this.icon,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<bool> show({
    required PermissionType permissionType,
    required String title,
    required String description,
    required IconData icon,
  }) async {
    final result = await Get.dialog<bool>(
      PermissionDisclosureDialog(
        permissionType: permissionType,
        title: title,
        description: description,
        icon: icon,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  /// Helper specifically for Location Disclosure
  static Future<bool> showLocationDisclosure({
    String appName = 'This app',
    String? customDescription,
  }) {
    return show(
      permissionType: PermissionType.location,
      title: 'Location Permission Needed',
      description:
          customDescription ??
          '$appName needs location access to provide accurate location-based services, nearby search, and address detection. Your location is only used while using these features.',
      icon: Icons.location_on_rounded,
    );
  }

  /// Helper specifically for Camera Disclosure
  static Future<bool> showCameraDisclosure({
    String appName = 'This app',
    String? customDescription,
  }) {
    return show(
      permissionType: PermissionType.camera,
      title: 'Camera Access Needed',
      description:
          customDescription ??
          '$appName needs camera access so you can take and upload photos for profile pictures, verification documents, and media attachments.',
      icon: Icons.camera_alt_rounded,
    );
  }

  /// Helper specifically for Storage / Photo Library Disclosure
  static Future<bool> showStorageDisclosure({
    String appName = 'This app',
    String? customDescription,
  }) {
    return show(
      permissionType: PermissionType.storage,
      title: 'Photos & Files Access Needed',
      description:
          customDescription ??
          '$appName needs access to your photos and files so you can select and upload documents, images, and attachments.',
      icon: Icons.photo_library_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 4,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(icon, size: 32.r, color: AppColors.primary),
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: title,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            CustomText(
              text: description,
              fontSize: 13.sp,
              color: Colors.black87,
              textAlign: TextAlign.center,
              maxLines: 6,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      } else {
                        Get.back(result: false);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: CustomText(
                      text: 'Deny',
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: CustomText(
                      text: 'Continue',
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
