import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final int? maxLines;
  final double? height;
  final double? letterSpacing;
  final double? decorationThickness;
  final TextOverflow? textOverflow;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final bool? softWrap;

  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.maxLines,
    this.height,
    this.letterSpacing,
    this.decorationThickness,
    this.textOverflow,
    this.decoration,
    this.decorationColor,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor =
        color ??
        style?.color ??
        Theme.of(context).textTheme.bodyMedium?.color ??
        AppColors.black;

    final TextOverflow? effectiveOverflow =
        textOverflow ?? (maxLines != null ? TextOverflow.ellipsis : null);

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: effectiveOverflow,
      softWrap: softWrap,
      style: GoogleFonts.inter(
        textStyle: style,
        fontSize: fontSize ?? style?.fontSize ?? 14.sp,
        color: effectiveColor,
        fontWeight: fontWeight ?? style?.fontWeight ?? FontWeight.w400,
        fontStyle: fontStyle ?? style?.fontStyle,
        height: height ?? style?.height,
        letterSpacing: letterSpacing ?? style?.letterSpacing,
        decoration: decoration ?? style?.decoration,
        decorationThickness: decorationThickness,
        decorationColor: decorationColor ?? effectiveColor,
      ),
    );
  }
}
