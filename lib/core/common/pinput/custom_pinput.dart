import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_structure/core/common/pinput/custom_pinput_theme.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class CustomPinput extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int length;
  final CustomPinputStyle style;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool forceErrorState;
  final PinputAutovalidateMode pinputAutovalidateMode;
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? obscuringWidget;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final PinAnimationType pinAnimationType;
  final Duration animationDuration;
  final Curve animationCurve;
  final HapticFeedbackType hapticFeedbackType;
  final bool closeKeyboardWhenCompleted;
  final bool showCursor;
  final Widget? cursor;
  final double? spacing;
  final Widget Function(int index)? separatorBuilder;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Color? fillColor;
  final Color? focusedFillColor;
  final Color? submittedFillColor;
  final Color? errorFillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? submittedBorderColor;
  final Color? errorBorderColor;
  final double? borderWidth;
  final double? focusedBorderWidth;
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;
  final MainAxisAlignment mainAxisAlignment;
  final TapRegionCallback? onTapOutside;
  final SmsRetriever? smsRetriever;
  final Widget Function(String? errorText, String pin)? errorBuilder;
  final PinTheme? customDefaultTheme;
  final PinTheme? customFocusedTheme;
  final PinTheme? customSubmittedTheme;
  final PinTheme? customErrorTheme;
  final PinTheme? customDisabledTheme;

  const CustomPinput({
    super.key,
    this.controller,
    this.focusNode,
    this.length = 4,
    this.style = CustomPinputStyle.roundedBox,
    this.onCompleted,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.errorText,
    this.forceErrorState = false,
    this.pinputAutovalidateMode = PinputAutovalidateMode.onSubmit,
    this.obscureText = false,
    this.obscuringCharacter = '●',
    this.obscuringWidget,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.pinAnimationType = PinAnimationType.scale,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.hapticFeedbackType = HapticFeedbackType.lightImpact,
    this.closeKeyboardWhenCompleted = true,
    this.showCursor = true,
    this.cursor,
    this.spacing,
    this.separatorBuilder,
    this.width,
    this.height,
    this.borderRadius,
    this.fillColor,
    this.focusedFillColor,
    this.submittedFillColor,
    this.errorFillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.submittedBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.focusedBorderWidth,
    this.textStyle,
    this.errorTextStyle,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onTapOutside,
    this.smsRetriever,
    this.errorBuilder,
    this.customDefaultTheme,
    this.customFocusedTheme,
    this.customSubmittedTheme,
    this.customErrorTheme,
    this.customDisabledTheme,
  }) : assert(length > 0, 'PIN length must be greater than 0');

  @override
  Widget build(BuildContext context) {
    // 1. Resolve Default PinTheme
    final defaultTheme =
        customDefaultTheme ??
        CustomPinputTheme.buildDefaultTheme(
          style: style,
          width: width,
          height: height,
          borderRadius: borderRadius,
          fillColor: fillColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          textStyle: textStyle,
        );

    // 2. Resolve Focused PinTheme
    final focusedTheme =
        customFocusedTheme ??
        CustomPinputTheme.buildFocusedTheme(
          defaultTheme: defaultTheme,
          style: style,
          focusedBorderColor: focusedBorderColor,
          focusedFillColor: focusedFillColor,
          focusedBorderWidth: focusedBorderWidth,
          borderRadius: borderRadius,
        );

    // 3. Resolve Submitted PinTheme
    final submittedTheme =
        customSubmittedTheme ??
        CustomPinputTheme.buildSubmittedTheme(
          defaultTheme: defaultTheme,
          style: style,
          submittedBorderColor: submittedBorderColor,
          submittedFillColor: submittedFillColor,
          borderRadius: borderRadius,
        );

    // 4. Resolve Error PinTheme
    final errorTheme =
        customErrorTheme ??
        CustomPinputTheme.buildErrorTheme(
          defaultTheme: defaultTheme,
          style: style,
          errorBorderColor: errorBorderColor,
          errorFillColor: errorFillColor,
          borderRadius: borderRadius,
        );

    // 5. Resolve Disabled PinTheme
    final disabledTheme =
        customDisabledTheme ??
        CustomPinputTheme.buildDisabledTheme(
          defaultTheme: defaultTheme,
          style: style,
          borderRadius: borderRadius,
        );

    // 6. Sleek Default Cursor
    final effectiveCursor =
        cursor ??
        Container(
          width: 2.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: focusedBorderColor ?? AppColors.primary,
            borderRadius: BorderRadius.circular(1.r),
          ),
        );

    final effectiveFormatters =
        inputFormatters ??
        (keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : null);

    return Pinput(
      controller: controller,
      focusNode: focusNode,
      length: length,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: focusedTheme,
      submittedPinTheme: submittedTheme,
      errorPinTheme: errorTheme,
      disabledPinTheme: disabledTheme,
      separatorBuilder:
          separatorBuilder ?? (index) => SizedBox(width: spacing ?? 10.w),
      mainAxisAlignment: mainAxisAlignment,
      onCompleted: onCompleted,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      errorText: errorText,
      forceErrorState: forceErrorState,
      pinputAutovalidateMode: pinputAutovalidateMode,
      errorTextStyle:
          errorTextStyle ??
          GoogleFonts.inter(
            fontSize: 12.sp,
            color: errorBorderColor ?? AppColors.red,
            fontWeight: FontWeight.w500,
          ),
      errorBuilder: errorBuilder,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      obscuringWidget: obscuringWidget,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      keyboardType: keyboardType,
      inputFormatters: effectiveFormatters ?? const [],
      pinAnimationType: pinAnimationType,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      hapticFeedbackType: hapticFeedbackType,
      closeKeyboardWhenCompleted: closeKeyboardWhenCompleted,
      showCursor: showCursor,
      cursor: effectiveCursor,
      onTapOutside:
          onTapOutside ??
          (event) => FocusManager.instance.primaryFocus?.unfocus(),
      smsRetriever: smsRetriever,
    );
  }
}
