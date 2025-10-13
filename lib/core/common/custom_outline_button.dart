import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    this.text,
    this.icon,
    this.borderColor,
    this.containerWidth,
    this.containerPadding,
    required this.onPressed,
    this.bacColor,
    this.textSize,
    this.textColor,
    this.radius,
  });

  final String? text;
  final Widget? icon;
  final Color? borderColor;
  final Color? bacColor;
  final double? containerWidth;
  final EdgeInsets? containerPadding;
  final VoidCallback onPressed;
  final double? textSize;
  final Color? textColor;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: bacColor ?? Color(0xfff3f3f4),
      child: InkWell(
        borderRadius: radius != null
            ? BorderRadius.circular(radius!)
            : BorderRadius.circular(10),
        // ignore: deprecated_member_use
        splashColor: Colors.white.withOpacity(0.5),
        onTap: onPressed,
        child: Container(
          width: containerWidth,
          padding:
              containerPadding ??
              EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor ?? Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                const SizedBox(),
                SizedBox(height: 23, width: 23, child: icon!),
              ],
              // SizedBox(
              //   width: getWidth(12),
              // ),
              CustomText(
                text: text ?? '',
                fontSize: textSize ?? 14,
                fontWeight: FontWeight.w500,
                color: textColor ?? Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}