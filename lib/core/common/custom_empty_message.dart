import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';

enum EmptyStateType { general }

class CustomEmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? customTitle;
  final String? customMessage;
  final String? searchQuery;
  final VoidCallback? onActionTap;
  final String? actionLabel;
  final IconData? icon;
  final Widget? customWidget;
  final Color? iconColor;
  final bool isCompact;

  const CustomEmptyState({
    super.key,
    this.type = EmptyStateType.general,
    this.customTitle,
    this.customMessage,
    this.searchQuery,
    this.onActionTap,
    this.actionLabel,
    this.icon,
    this.customWidget,
    this.iconColor,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getEmptyStateConfig();
    final effectiveIcon = icon ?? config.icon;
    final effectiveIconColor = iconColor ?? AppColors.primary;

    final String effectiveTitle =
        customTitle ??
        (searchQuery != null && searchQuery!.trim().isNotEmpty
            ? "No Results Found"
            : config.title);

    final String effectiveMessage =
        customMessage ??
        (searchQuery != null && searchQuery!.trim().isNotEmpty
            ? "We couldn't find any matches for \"${searchQuery!.trim()}\". Try checking for typos or searching with different keywords."
            : config.message);

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16.w : 32.w,
            vertical: isCompact ? 20.h : 48.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (customWidget != null)
                customWidget!
              else
                Container(
                  width: isCompact ? 70.w : 110.w,
                  height: isCompact ? 70.w : 110.w,
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    effectiveIcon,
                    size: isCompact ? 36.sp : 50.sp,
                    color: effectiveIconColor.withValues(alpha: 0.8),
                  ),
                ),

              SizedBox(height: isCompact ? 14.h : 20.h),

              CustomText(
                text: effectiveTitle,
                fontSize: isCompact ? 16.sp : 19.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              CustomText(
                text: effectiveMessage,
                fontSize: isCompact ? 12.sp : 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                textAlign: TextAlign.center,
                maxLines: 4,
              ),

              if (onActionTap != null) ...[
                SizedBox(height: isCompact ? 18.h : 28.h),
                ElevatedButton(
                  onPressed: onActionTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 20.w : 28.w,
                      vertical: isCompact ? 10.h : 13.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: CustomText(
                    text: actionLabel ?? config.actionLabel,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  EmptyStateConfig _getEmptyStateConfig() {
    switch (type) {
      case EmptyStateType.general:
        return EmptyStateConfig(
          icon: Icons.inbox_outlined,
          title: "Nothing Here",
          message: "There is no data to display at the moment.",
          actionLabel: "Go Back",
        );
    }
  }
}

class EmptyStateConfig {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;

  EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
  });
}
