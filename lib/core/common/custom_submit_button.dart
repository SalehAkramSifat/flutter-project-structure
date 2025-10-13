import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? prefixIcon;
  final Widget? nextIcon;
  final Widget? child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final String? image;
  final bool showPrefixIcon;
  final bool showNextIcon;

  // ✅ add loading
  final bool isLoading;

  const CustomSubmitButton({
    super.key,
    required this.text,
    required this.onTap,
    this.prefixIcon,
    this.nextIcon,
    this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.textColor,
    this.fontSize,
    this.image,
    this.showPrefixIcon = true,
    this.showNextIcon = true,
    this.isLoading = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.black,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: InkWell(
        splashColor: Colors.white.withAlpha(50),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        onTap: isLoading ? null : onTap, // disable while loading
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null && showPrefixIcon) ...[
                const SizedBox(),
                SizedBox(height: 22, width: 22, child: prefixIcon!),
              ],
              SizedBox(width: 8),

              // ✅ text or loader
              if (isLoading)
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: textColor ?? Colors.white,
                    strokeWidth: 2,
                  ),
                )
              else
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: fontSize ?? 16,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? Colors.white,
                  ),
                ),

              if (child != null) ...[child!],
              if (nextIcon != null && showNextIcon) ...[
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: SizedBox(width: 25, child: nextIcon!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}