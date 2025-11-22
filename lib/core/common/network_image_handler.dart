import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/image_path.dart';

class NetworkOrPlaceholderClipImage extends StatelessWidget {
  final String? imageUrl;
  final String? customPlaceholder;
  final CustomClipper<Path> clipper;
  final BoxFit fit;
  final double? width;
  final double? height;

  const NetworkOrPlaceholderClipImage({
    super.key,
    required this.clipper,
    this.imageUrl,
    this.customPlaceholder,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final hasNetworkImage =
        imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl!.startsWith('http');

    final fallbackImage = customPlaceholder ?? ImagePath.placeholder;

    return ClipPath(
      clipper: clipper,
      child: hasNetworkImage
          ? Image.network(
              imageUrl!,
              fit: fit,
              width: width,
              height: height,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                fallbackImage,
                fit: fit,
                width: width,
                height: height,
              ),
            )
          : Image.asset(fallbackImage, fit: fit, width: width, height: height),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
