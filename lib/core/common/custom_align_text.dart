import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlignText extends StatelessWidget {
  final String text;
  final AlignmentGeometry alignment;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? decorationThickness;
  final TextOverflow? textOverflow;
  final TextDecoration? decoration;
  final Color? decorationColor;

  const CustomAlignText({
    super.key,
    required this.text,
    this.alignment = Alignment.centerLeft,
    this.textAlign,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.left,
        style: GoogleFonts.inter(
          decoration: decoration,
          decorationThickness: decorationThickness,
          decorationColor: decorationColor ?? color ?? AppColors.primary,
          fontSize: fontSize ?? 14.sp,
          color: color ?? const Color(0xFF6B7280),
          fontWeight: fontWeight ?? FontWeight.w700,
        ),
        overflow: textOverflow,
        maxLines: maxLines,
      ),
    );
  }
}
