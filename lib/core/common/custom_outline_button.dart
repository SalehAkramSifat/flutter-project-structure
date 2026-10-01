import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';

class CustomOutlineButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? textSize;
  final FontWeight? fontWeight;
  final double radius;
  final double borderWidth;
  final bool isLoading;
  final bool isFullWidth;

  const CustomOutlineButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.textSize,
    this.fontWeight,
    this.radius = 12.0,
    this.borderWidth = 1.2,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final effectiveBorderColor = isEnabled
        ? (borderColor ?? AppColors.primary)
        : Colors.grey.shade400;

    final effectiveTextColor = isEnabled
        ? (textColor ?? AppColors.primary)
        : Colors.grey.shade500;

    final BorderRadius effectiveRadius = BorderRadius.circular(radius.r);

    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: effectiveRadius,
      child: InkWell(
        borderRadius: effectiveRadius,
        splashColor: (borderColor ?? AppColors.primary).withValues(alpha: 0.1),
        highlightColor: (borderColor ?? AppColors.primary).withValues(
          alpha: 0.05,
        ),
        onTap: isEnabled ? onPressed : null,
        child: Container(
          width: isFullWidth ? double.infinity : width,
          height: height,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: effectiveRadius,
            border: Border.all(color: effectiveBorderColor, width: borderWidth),
          ),
          child: Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // লোডিং স্পিনার
              if (isLoading) ...[
                SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: effectiveBorderColor,
                  ),
                ),
                SizedBox(width: 10.w),
              ] else if (icon != null) ...[
                icon!,
                SizedBox(width: 8.w),
              ],

              if (text != null && text!.isNotEmpty)
                Flexible(
                  child: CustomText(
                    text: text!,
                    fontSize: textSize ?? 14.sp,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    color: effectiveTextColor,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
