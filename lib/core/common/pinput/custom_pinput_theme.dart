import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

enum CustomPinputStyle { roundedBox, filled, circle, underline }

class CustomPinputTheme {
  CustomPinputTheme._();

  static PinTheme buildDefaultTheme({
    required CustomPinputStyle style,
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    TextStyle? textStyle,
  }) {
    final effectiveWidth =
        width ?? (style == CustomPinputStyle.circle ? 54.r : 52.w);
    final effectiveHeight =
        height ?? (style == CustomPinputStyle.circle ? 54.r : 56.h);
    final effectiveBorderWidth = borderWidth ?? 1.5;

    final effectiveTextStyle =
        textStyle ??
        GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        );

    BoxDecoration decoration;

    switch (style) {
      case CustomPinputStyle.circle:
        decoration = BoxDecoration(
          shape: BoxShape.circle,
          color: fillColor ?? const Color(0xFFF8FAFC),
          border: Border.all(
            color: borderColor ?? const Color(0xFFE2E8F0),
            width: effectiveBorderWidth,
          ),
        );
        break;

      case CustomPinputStyle.filled:
        decoration = BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          color: fillColor ?? const Color(0xFFF1F5F9),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: effectiveBorderWidth,
          ),
        );
        break;

      case CustomPinputStyle.underline:
        decoration = BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: borderColor ?? const Color(0xFFCBD5E1),
              width: (borderWidth ?? 2.0).h,
            ),
          ),
        );
        break;

      case CustomPinputStyle.roundedBox:
        decoration = BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          color: fillColor ?? Colors.white,
          border: Border.all(
            color: borderColor ?? const Color(0xFFE2E8F0),
            width: effectiveBorderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );
        break;
    }

    return PinTheme(
      width: effectiveWidth,
      height: effectiveHeight,
      textStyle: effectiveTextStyle,
      decoration: decoration,
    );
  }

  static PinTheme buildFocusedTheme({
    required PinTheme defaultTheme,
    required CustomPinputStyle style,
    Color? focusedBorderColor,
    Color? focusedFillColor,
    double? focusedBorderWidth,
    BorderRadiusGeometry? borderRadius,
  }) {
    final activeBorderColor = focusedBorderColor ?? AppColors.primary;
    final activeBorderWidth = focusedBorderWidth ?? 2.0;

    switch (style) {
      case CustomPinputStyle.circle:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: focusedFillColor ?? Colors.white,
            border: Border.all(
              color: activeBorderColor,
              width: activeBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: activeBorderColor.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        );

      case CustomPinputStyle.filled:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            color: focusedFillColor ?? Colors.white,
            border: Border.all(
              color: activeBorderColor,
              width: activeBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: activeBorderColor.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        );

      case CustomPinputStyle.underline:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: activeBorderColor,
                width: activeBorderWidth.h,
              ),
            ),
          ),
        );

      case CustomPinputStyle.roundedBox:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            color: focusedFillColor ?? Colors.white,
            border: Border.all(
              color: activeBorderColor,
              width: activeBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: activeBorderColor.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        );
    }
  }

  static PinTheme buildSubmittedTheme({
    required PinTheme defaultTheme,
    required CustomPinputStyle style,
    Color? submittedBorderColor,
    Color? submittedFillColor,
    BorderRadiusGeometry? borderRadius,
  }) {
    final effectiveBorderColor =
        submittedBorderColor ?? AppColors.primary.withValues(alpha: 0.6);

    switch (style) {
      case CustomPinputStyle.circle:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: submittedFillColor ?? Colors.white,
            border: Border.all(color: effectiveBorderColor, width: 1.5),
          ),
        );

      case CustomPinputStyle.filled:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            color: submittedFillColor ?? const Color(0xFFF8FAFC),
            border: Border.all(color: effectiveBorderColor, width: 1.5),
          ),
        );

      case CustomPinputStyle.underline:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: effectiveBorderColor, width: 2.0.h),
            ),
          ),
        );

      case CustomPinputStyle.roundedBox:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            color: submittedFillColor ?? Colors.white,
            border: Border.all(color: effectiveBorderColor, width: 1.5),
          ),
        );
    }
  }

  static PinTheme buildErrorTheme({
    required PinTheme defaultTheme,
    required CustomPinputStyle style,
    Color? errorBorderColor,
    Color? errorFillColor,
    BorderRadiusGeometry? borderRadius,
  }) {
    final effectiveErrorBorder = errorBorderColor ?? AppColors.red;

    switch (style) {
      case CustomPinputStyle.circle:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: errorFillColor ?? const Color(0xFFFEF2F2),
            border: Border.all(color: effectiveErrorBorder, width: 1.5),
          ),
        );

      case CustomPinputStyle.filled:
      case CustomPinputStyle.roundedBox:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            color: errorFillColor ?? const Color(0xFFFEF2F2),
            border: Border.all(color: effectiveErrorBorder, width: 1.5),
          ),
        );

      case CustomPinputStyle.underline:
        return defaultTheme.copyWith(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: effectiveErrorBorder, width: 2.0.h),
            ),
          ),
        );
    }
  }

  static PinTheme buildDisabledTheme({
    required PinTheme defaultTheme,
    required CustomPinputStyle style,
    BorderRadiusGeometry? borderRadius,
  }) {
    return defaultTheme.copyWith(
      decoration: BoxDecoration(
        shape: style == CustomPinputStyle.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: style != CustomPinputStyle.circle
            ? (borderRadius ?? BorderRadius.circular(12.r))
            : null,
        color: const Color(0xFFF1F5F9),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
    );
  }
}
