import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:get/get.dart';

class CustomConfirmationPopup extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final IconData? icon;

  const CustomConfirmationPopup({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
    this.onCancel,
    this.isDestructive = false,
    this.icon,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
    VoidCallback? onCancel,
    bool isDestructive = false,
    IconData? icon,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return CustomConfirmationPopup(
          title: title,
          message: message,
          onConfirm: onConfirm,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          onCancel: onCancel,
          isDestructive: isDestructive,
          icon: icon,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryActionColor = isDestructive
        ? Colors.redAccent
        : AppColors.primary;
    final IconData displayIcon =
        icon ??
        (isDestructive
            ? Icons.warning_amber_rounded
            : Icons.info_outline_rounded);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryActionColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(displayIcon, size: 40, color: primaryActionColor),
            ),
            const SizedBox(height: 20),

            CustomText(
              text: title,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            CustomText(
              text: message,
              fontSize: 14,
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      }
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.grey.shade700,
                    ),
                    child: CustomText(
                      text: cancelButtonText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryActionColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: CustomText(
                      text: confirmButtonText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
