import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';

class NetworkImageHandler extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final CustomClipper<Path>? clipper;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final String? assetFallback;

  const NetworkImageHandler({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isCircle = false,
    this.clipper,
    this.placeholderWidget,
    this.errorWidget,
    this.assetFallback,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    final validUrl =
        imageUrl != null &&
        imageUrl!.trim().isNotEmpty &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'));

    if (!validUrl) {
      content = _buildErrorWidget();
    } else {
      content = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholderWidget ?? _buildDefaultLoader(loadingProgress);
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildErrorWidget();
        },
      );
    }

    if (clipper != null) {
      content = ClipPath(clipper: clipper, child: content);
    } else if (isCircle) {
      content = ClipOval(child: content);
    } else if (borderRadius != null) {
      content = ClipRRect(borderRadius: borderRadius!, child: content);
    }

    return SizedBox(width: width, height: height, child: content);
  }

  Widget _buildDefaultLoader(ImageChunkEvent progress) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade100,
      child: Center(
        child: SizedBox(
          width: 20.r,
          height: 20.r,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
            value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (assetFallback != null) {
      return Image.asset(
        assetFallback!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallbackIcon(),
      );
    }
    return _buildFallbackIcon();
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey.shade500,
        size: ((width ?? height ?? 40.r) * 0.4).clamp(16.0, 48.0),
      ),
    );
  }
}
