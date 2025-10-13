import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';

class Aligntext extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? textColor;
  const Aligntext({
    super.key,
    required this.text,
    this.fontSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: text,
        fontSize: fontSize ?? 14.sp,
        fontWeight: FontWeight.w700,
        color: textColor ?? Colors.black,
      ),
    );
  }
}

class SpechalAlignText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? textColor;
  const SpechalAlignText({
    super.key,
    required this.text,
    this.fontSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: text,
        fontSize: fontSize ?? 14.sp,
        fontWeight: FontWeight.w400,
        color: textColor ?? Colors.black,
      ),
    );
  }
}
