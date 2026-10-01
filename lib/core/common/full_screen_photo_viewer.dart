import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';

class FullScreenPhotoViewer extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const FullScreenPhotoViewer({
    super.key,
    required this.photos,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenPhotoViewer> createState() => _FullScreenPhotoViewerState();
}

class _FullScreenPhotoViewerState extends State<FullScreenPhotoViewer> {
  late PageController _pageController;
  late ScrollController _thumbnailScrollController;
  late int _currentIndex;
  bool _isZoomed = false;
  bool _showOverlays = true;

  @override
  void initState() {
    super.initState();
    final safeInitial = widget.photos.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, widget.photos.length - 1);

    _currentIndex = safeInitial;
    _pageController = PageController(initialPage: safeInitial);
    _thumbnailScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToThumbnail(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbnailScrollController.dispose();
    super.dispose();
  }

  void _scrollToThumbnail(int index) {
    if (!_thumbnailScrollController.hasClients || widget.photos.isEmpty) return;
    const double itemWidth = 68.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetOffset =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _thumbnailScrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _thumbnailScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _toggleOverlays() {
    setState(() {
      _showOverlays = !_showOverlays;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: CustomText(
            text: 'No photos available',
            fontSize: 16.sp,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            physics: _isZoomed
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _isZoomed = false;
              });
              _scrollToThumbnail(index);
            },
            itemBuilder: (context, index) {
              return _ZoomablePhotoView(
                photoPath: widget.photos[index],
                index: index,
                onTap: _toggleOverlays,
                onZoomChanged: (isZoomed) {
                  if (_isZoomed != isZoomed) {
                    setState(() {
                      _isZoomed = isZoomed;
                    });
                  }
                },
              );
            },
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: _showOverlays ? Offset.zero : const Offset(0, -1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _showOverlays ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withAlpha(180), Colors.transparent],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 26.sp,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Text(
                            '${_currentIndex + 1} / ${widget.photos.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 48.w),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (widget.photos.length > 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: _showOverlays ? Offset.zero : const Offset(0, 1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _showOverlays ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withAlpha(180),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Container(
                        height: 80.h,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: ListView.builder(
                          controller: _thumbnailScrollController,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: widget.photos.length,
                          itemBuilder: (context, index) {
                            final isSelected = index == _currentIndex;
                            return GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: SizedBox(
                                    width: 60.w,
                                    height: 60.h,
                                    child: _buildThumbnailImage(
                                      widget.photos[index],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnailImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _thumbnailError(),
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _thumbnailError(),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _thumbnailError(),
      );
    }
  }

  Widget _thumbnailError() {
    return Container(
      color: Colors.grey.shade900,
      child: Icon(Icons.broken_image, color: Colors.white54, size: 22.sp),
    );
  }
}

class _ZoomablePhotoView extends StatefulWidget {
  final String photoPath;
  final int index;
  final VoidCallback onTap;
  final ValueChanged<bool> onZoomChanged;

  const _ZoomablePhotoView({
    required this.photoPath,
    required this.index,
    required this.onTap,
    required this.onZoomChanged,
  });

  @override
  State<_ZoomablePhotoView> createState() => _ZoomablePhotoViewState();
}

class _ZoomablePhotoViewState extends State<_ZoomablePhotoView>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _zoomAnimation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        if (_zoomAnimation != null) {
          _transformationController.value = _zoomAnimation!.value;
        }
      });
    _transformationController.addListener(_onTransformationChanged);
  }

  void _onTransformationChanged() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    widget.onZoomChanged(scale > 1.05);
  }

  void _handleDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final Matrix4 endMatrix;

    if (currentScale > 1.2) {
      endMatrix = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      endMatrix = Matrix4.identity()
        ..translateByDouble(-position.dx * 1.5, -position.dy * 1.5, 0.0, 1.0)
        ..scaleByDouble(2.5, 2.5, 1.0, 1.0);
    }

    _zoomAnimation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: endMatrix,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.forward(from: 0).then((_) {
      _transformationController.value = endMatrix;
    });
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 1.0,
          maxScale: 4.0,
          clipBehavior: Clip.none,
          child: _buildFullImage(widget.photoPath),
        ),
      ),
    );
  }

  Widget _buildFullImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fullError(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fullError(),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fullError(),
      );
    }
  }

  Widget _fullError() {
    return Center(
      child: Icon(
        Icons.broken_image_rounded,
        size: 70.sp,
        color: Colors.white54,
      ),
    );
  }
}

extension PhotoViewerNavigation on BuildContext {
  void openPhotoViewer(List<String> photos, {int initialIndex = 0}) {
    if (photos.isEmpty) return;
    Navigator.of(this).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullScreenPhotoViewer(photos: photos, initialIndex: initialIndex),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
        opaque: false,
      ),
    );
  }
}
