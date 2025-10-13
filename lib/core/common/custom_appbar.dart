import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:flutter_project_structure/core/utils/icon_path.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? icon;
  final double? fontSize;
  final Color? titleColor;
  final Color? iconColor;
  final bool centerTitle;
  final Widget? trailing;
  final bool backIcon; // <-- added

  const CustomAppbar({
    super.key,
    this.title,
    this.icon,
    this.fontSize,
    this.titleColor,
    this.iconColor,
    this.centerTitle = false,
    this.trailing,
    this.backIcon = true, // <-- default true (always show)
  });

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.trim().isNotEmpty;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      // color: AppColors.backgroundLight,
      padding: EdgeInsets.only(top: topPadding),
      child: SizedBox(
        height: 52.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (backIcon)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      icon ??
                      Image.asset(
                        IconPath.arrowBack,
                        color: Colors.black,
                        width: 18.w,
                        height: 13.h,
                      ),
                  color: iconColor,
                ),
              ),
            if (hasTitle)
              Align(
                alignment: centerTitle
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Padding(
                  padding: centerTitle
                      ? EdgeInsets.zero
                      : EdgeInsets.only(left: 45.w), // <-- সবসময় 45.w offset
                  child: CustomText(
                    text: title!,
                    fontSize: fontSize ?? 20.sp,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? Colors.black,
                  ),
                ),
              ),
            if (trailing != null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: trailing!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52.0);
}