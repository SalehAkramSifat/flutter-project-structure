import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableCustomText extends StatefulWidget {
  final String text;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final double? height;
  final int collapsedMaxLines;
  final Color? expandTextColor;
  final String expandText;
  final String collapseText;
  final bool showArrow;
  final bool canTapTextToExpand;
  final Duration animationDuration;
  final ValueChanged<bool>? onToggle;

  const ExpandableCustomText({
    super.key,
    required this.text,
    this.textAlign,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.height = 1.4,
    this.collapsedMaxLines = 3,
    this.expandTextColor,
    this.expandText = 'See More',
    this.collapseText = 'See Less',
    this.showArrow = true,
    this.canTapTextToExpand = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.onToggle,
  });

  @override
  State<ExpandableCustomText> createState() => _ExpandableCustomTextState();
}

class _ExpandableCustomTextState extends State<ExpandableCustomText> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onToggle?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        widget.color ??
        Theme.of(context).textTheme.bodyMedium?.color ??
        AppColors.black;

    final effectiveActionColor = widget.expandTextColor ?? AppColors.primary;

    final textStyle = GoogleFonts.inter(
      fontSize: widget.fontSize ?? 14.sp,
      color: effectiveColor,
      fontWeight: widget.fontWeight ?? FontWeight.w400,
      height: widget.height,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.collapsedMaxLines,
          textDirection: TextDirection.ltr,
          textAlign: widget.textAlign ?? TextAlign.start,
        )..layout(maxWidth: constraints.maxWidth);

        final bool hasExceeded = textPainter.didExceedMaxLines;
        final bool showActionButton = hasExceeded || _isExpanded;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (widget.canTapTextToExpand && hasExceeded)
                  ? _toggleExpanded
                  : null,
              behavior: HitTestBehavior.opaque,
              child: AnimatedCrossFade(
                firstChild: Text(
                  widget.text,
                  textAlign: widget.textAlign,
                  style: textStyle,
                  maxLines: widget.collapsedMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
                secondChild: Text(
                  widget.text,
                  textAlign: widget.textAlign,
                  style: textStyle,
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: widget.animationDuration,
                alignment: Alignment.topLeft,
              ),
            ),
            if (showActionButton)
              GestureDetector(
                onTap: _toggleExpanded,
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? widget.collapseText : widget.expandText,
                        style: GoogleFonts.inter(
                          fontSize: widget.fontSize ?? 14.sp,
                          fontWeight: FontWeight.w600,
                          color: effectiveActionColor,
                        ),
                      ),
                      if (widget.showArrow) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 18.r,
                          color: effectiveActionColor,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
