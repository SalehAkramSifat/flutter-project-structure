import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? nextIcon;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? textColor;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? image;
  final double? width;
  final double? height;
  final bool isFullWidth;
  final bool showPrefixIcon;
  final bool showNextIcon;
  final bool isLoading;
  final bool isEnabled;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const CustomSubmitButton({
    super.key,
    required this.text,
    this.onTap,
    this.prefixIcon,
    this.nextIcon,
    this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.textColor,
    this.disabledColor,
    this.disabledTextColor,
    this.fontSize,
    this.fontWeight,
    this.image,
    this.width,
    this.height,
    this.isFullWidth = true,
    this.showPrefixIcon = true,
    this.showNextIcon = true,
    this.isLoading = false,
    this.isEnabled = true,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final bool canTap = isEnabled && !isLoading && onTap != null;
    final BorderRadius effectiveRadius =
        borderRadius ?? BorderRadius.circular(8.r);

    final Color effectiveBgColor = canTap
        ? (color ?? AppColors.primary)
        : (disabledColor ?? Colors.grey.shade400);

    final Color effectiveTextColor = canTap
        ? (textColor ?? Colors.white)
        : (disabledTextColor ?? Colors.white70);

    Widget effectivePrefix;
    if (image != null && image!.isNotEmpty) {
      effectivePrefix = Image.asset(
        image!,
        height: 20.r,
        width: 20.r,
        fit: BoxFit.contain,
      );
    } else {
      effectivePrefix = prefixIcon ?? const SizedBox.shrink();
    }

    Widget buttonContent = Material(
      color: effectiveBgColor,
      borderRadius: effectiveRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: canTap ? Colors.white.withAlpha(50) : Colors.transparent,
        highlightColor: canTap
            ? Colors.white.withAlpha(25)
            : Colors.transparent,
        borderRadius: effectiveRadius,
        onTap: canTap ? onTap : null,
        child: Container(
          width: isFullWidth ? (width ?? double.infinity) : width,
          height: height,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: effectiveRadius,
            border: border,
          ),
          child: Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 20.r,
                  width: 20.r,
                  child: CircularProgressIndicator(
                    color: effectiveTextColor,
                    strokeWidth: 2.5,
                  ),
                )
              else ...[
                if ((prefixIcon != null || image != null) &&
                    showPrefixIcon) ...[
                  SizedBox(
                    height: 20.r,
                    width: 20.r,
                    child: Center(child: effectivePrefix),
                  ),
                  SizedBox(width: 8.w),
                ],

                if (child != null)
                  child!
                else
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: fontSize ?? 16.sp,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      color: effectiveTextColor,
                    ),
                  ),

                if (nextIcon != null && showNextIcon) ...[
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 20.r,
                    width: 20.r,
                    child: Center(child: nextIcon),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );

    if (boxShadow != null && canTap) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          boxShadow: boxShadow,
        ),
        child: buttonContent,
      );
    }

    return buttonContent;
  }
}
