import 'package:adi/core/utils/app_sizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableCustomText extends StatefulWidget {
  final String text;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final int collapsedMaxLines; // Lines to show when collapsed
  final Color? expandTextColor;
  final String expandText;
  final String collapseText;

  const ExpandableCustomText({
    super.key,
    required this.text,
    this.textAlign,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.collapsedMaxLines = 4,
    this.expandTextColor,
    this.expandText = 'See More',
    this.collapseText = 'See Less',
  });

  @override
  State<ExpandableCustomText> createState() => _ExpandableCustomTextState();
}

class _ExpandableCustomTextState extends State<ExpandableCustomText> {
  bool _isExpanded = false;
  bool _needsExpansion = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.inter(
      fontSize: widget.fontSize ?? 18.sp,
      color: widget.color ?? const Color(0xFF1A1A1A),
      fontWeight: widget.fontWeight ?? FontWeight.w500,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if text needs expansion
        final textSpan = TextSpan(text: widget.text, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.collapsedMaxLines,
          textDirection: TextDirection.ltr,
          textAlign: widget.textAlign ?? TextAlign.start,
        )..layout(maxWidth: constraints.maxWidth);

        final exceeded = textPainter.didExceedMaxLines;

        // Update needs expansion state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_needsExpansion != exceeded && mounted) {
            setState(() {
              _needsExpansion = exceeded;
            });
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
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
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.topLeft,
            ),
            if (_needsExpansion || _isExpanded)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    _isExpanded ? widget.collapseText : widget.expandText,
                    style: GoogleFonts.inter(
                      fontSize: widget.fontSize ?? 18.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.expandTextColor ?? const Color(0xff2972FF),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
