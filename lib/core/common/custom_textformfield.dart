import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmit;
  final Function(PointerDownEvent)? onTapOutside;
  final Color? containerColor;
  final Color? containerBorderColor;
  final double? containerBorderWidth;
  final double? radius;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool readonly;
  final bool? enabled;
  final bool autofocus;
  final bool obscureText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefixIcon;
  final String? prefixIconPath;
  final Color? prefixIconColor;
  final double? prefixIconHeight;
  final double? prefixIconWidth;
  final String? prefixText;
  final TextStyle? prefixTextStyle;
  final Widget? suffixIcon;
  final String? suffixIconPath;
  final Color? suffixIconColor;
  final double? suffixIconHeight;
  final double? suffixIconWidth;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.hintTextStyle,
    this.style,
    this.onChanged,
    this.onFieldSubmit,
    this.onTapOutside,
    this.containerColor,
    this.containerBorderColor,
    this.containerBorderWidth,
    this.radius,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.readonly = false,
    this.enabled,
    this.autofocus = false,
    this.obscureText = false,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.prefixIcon,
    this.prefixIconPath,
    this.prefixIconColor,
    this.prefixIconHeight,
    this.prefixIconWidth,
    this.prefixText,
    this.prefixTextStyle,
    this.suffixIcon,
    this.suffixIconPath,
    this.suffixIconColor,
    this.suffixIconHeight,
    this.suffixIconWidth,
    this.suffixText,
    this.suffixTextStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.onTap,
    this.contentPadding,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ? true : widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant CustomTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isPassword && oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveRadius = BorderRadius.circular(
      widget.radius ?? 12.r,
    );
    final double effectiveBorderWidth = widget.containerBorderWidth ?? 1.2;
    final Color effectiveBorderColor =
        widget.containerBorderColor ?? AppColors.textFormFieldBorder;

    final OutlineInputBorder defaultEnabledBorder = OutlineInputBorder(
      borderRadius: effectiveRadius,
      borderSide: BorderSide(
        color: effectiveBorderColor,
        width: effectiveBorderWidth,
      ),
    );

    final OutlineInputBorder defaultFocusedBorder = OutlineInputBorder(
      borderRadius: effectiveRadius,
      borderSide: BorderSide(
        color: AppColors.primary,
        width: effectiveBorderWidth + 0.3,
      ),
    );

    final OutlineInputBorder defaultErrorBorder = OutlineInputBorder(
      borderRadius: effectiveRadius,
      borderSide: BorderSide(
        color: AppColors.error,
        width: effectiveBorderWidth,
      ),
    );

    final OutlineInputBorder defaultFocusedErrorBorder = OutlineInputBorder(
      borderRadius: effectiveRadius,
      borderSide: BorderSide(
        color: AppColors.error,
        width: effectiveBorderWidth + 0.3,
      ),
    );

    Widget? effectivePrefixIcon;
    if (widget.prefixIcon != null) {
      effectivePrefixIcon = widget.prefixIcon;
    } else if (widget.prefixIconPath != null) {
      effectivePrefixIcon = Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Image.asset(
          widget.prefixIconPath!,
          width: widget.prefixIconWidth ?? 20.r,
          height: widget.prefixIconHeight ?? 20.r,
          color: widget.prefixIconColor,
          fit: BoxFit.contain,
        ),
      );
    }

    Widget? effectiveSuffixIcon;
    if (widget.isPassword) {
      effectiveSuffixIcon = IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: widget.suffixIconColor ?? AppColors.textSecondary,
          size: 20.r,
        ),
        splashRadius: 20.r,
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      effectiveSuffixIcon = widget.suffixIcon;
    } else if (widget.suffixIconPath != null) {
      effectiveSuffixIcon = Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Image.asset(
          widget.suffixIconPath!,
          width: widget.suffixIconWidth ?? 20.r,
          height: widget.suffixIconHeight ?? 20.r,
          color: widget.suffixIconColor,
          fit: BoxFit.contain,
        ),
      );
    }

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textAlignVertical: TextAlignVertical.center,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmit,
      onTapOutside:
          widget.onTapOutside ?? (event) => FocusScope.of(context).unfocus(),
      readOnly: widget.readonly,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      obscureText: _obscureText,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      autovalidateMode:
          widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primary,
      onTap: widget.onTap,
      style:
          widget.style ??
          GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: widget.containerColor ?? Colors.white,
        hintText: widget.hintText,
        hintStyle:
            widget.hintTextStyle ??
            GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.error,
        ),
        prefixText: widget.prefixText != null ? '${widget.prefixText}  ' : null,
        prefixStyle:
            widget.prefixTextStyle ??
            GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
        prefixIcon: effectivePrefixIcon,
        prefixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 44.h),
        suffixText: widget.suffixText != null ? '  ${widget.suffixText}' : null,
        suffixStyle:
            widget.suffixTextStyle ??
            GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
        suffixIcon: effectiveSuffixIcon,
        suffixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 44.h),
        border: widget.border ?? defaultEnabledBorder,
        enabledBorder: widget.enabledBorder ?? defaultEnabledBorder,
        focusedBorder: widget.focusedBorder ?? defaultFocusedBorder,
        errorBorder: widget.errorBorder ?? defaultErrorBorder,
        focusedErrorBorder:
            widget.focusedErrorBorder ?? defaultFocusedErrorBorder,
        disabledBorder: OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: effectiveBorderWidth,
          ),
        ),
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      ),
    );
  }
}
