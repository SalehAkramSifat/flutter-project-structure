import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/common/custom_text.dart';
import 'package:flutter_project_structure/core/helper/pdf_downloader.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/core/utils/app_sizer.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    this.title = 'Document Viewer',
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfViewerController;

  int _pageCount = 0;
  int _currentPage = 1;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isDownloading = false;
  int _reloadKey = 0;
  String _errorMessage = '';
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.25).clamp(1.0, 3.0);
      _pdfViewerController.zoomLevel = _zoomLevel;
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.25).clamp(1.0, 3.0);
      _pdfViewerController.zoomLevel = _zoomLevel;
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = 1.0;
      _pdfViewerController.zoomLevel = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: widget.title,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                CustomText(
                  text: 'PDF Document Viewer',
                  fontSize: 11.sp,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
        actions: [
          _isDownloading
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Center(
                    child: SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: Colors.white,
                    size: 22.r,
                  ),
                  tooltip: 'Download PDF',
                  onPressed: () async {
                    setState(() => _isDownloading = true);
                    await PdfDownloader.downloadPdf(
                      widget.pdfUrl,
                      title: widget.title,
                    );
                    if (mounted) {
                      setState(() => _isDownloading = false);
                    }
                  },
                ),
          if (_pageCount > 0)
            Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Center(
                child: CustomText(
                  text: '$_currentPage / $_pageCount',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // PDF Viewer
          if (!_hasError)
            SfPdfViewer.network(
              widget.pdfUrl,
              key: ValueKey('pdf_viewer_$_reloadKey'),
              controller: _pdfViewerController,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                if (!mounted) return;
                setState(() {
                  _pageCount = details.document.pages.count;
                  _isLoading = false;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                if (!mounted) return;
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                  _errorMessage = details.description;
                });
              },
              onPageChanged: (PdfPageChangedDetails details) {
                if (!mounted) return;
                setState(() {
                  _currentPage = details.newPageNumber;
                });
              },
            ),

          // Loading Overlay
          if (_isLoading && !_hasError)
            Container(
              color: const Color(0xFF0F172A),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      text: 'Loading PDF document...',
                      fontSize: 13.sp,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

          if (_hasError)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.red.shade400.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        color: Colors.red.shade400,
                        size: 48.r,
                      ),
                      SizedBox(height: 16.h),
                      CustomText(
                        text: 'Unable to Load Document',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: _errorMessage.isNotEmpty
                            ? _errorMessage
                            : 'Please check your internet connection or try again later.',
                        fontSize: 12.sp,
                        color: const Color(0xFF94A3B8),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _hasError = false;
                            _isLoading = true;
                            _reloadKey++;
                          });
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Floating Control Toolbar
          if (!_isLoading && !_hasError)
            Positioned(
              bottom: 24.h,
              left: 20.w,
              right: 20.w,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xEE0F172A),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Zoom Out
                      IconButton(
                        onPressed: _zoomOut,
                        icon: const Icon(
                          Icons.zoom_out_rounded,
                          color: Colors.white,
                        ),
                        tooltip: 'Zoom Out',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.all(6.r),
                      ),
                      SizedBox(width: 4.w),
                      // Zoom Reset
                      GestureDetector(
                        onTap: _resetZoom,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomText(
                            text: '${(_zoomLevel * 100).toInt()}%',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // Zoom In
                      IconButton(
                        onPressed: _zoomIn,
                        icon: const Icon(
                          Icons.zoom_in_rounded,
                          color: Colors.white,
                        ),
                        tooltip: 'Zoom In',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.all(6.r),
                      ),
                      Container(
                        height: 20.h,
                        width: 1,
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      // Previous Page
                      IconButton(
                        onPressed: _currentPage > 1
                            ? () => _pdfViewerController.previousPage()
                            : null,
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: _currentPage > 1
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                        tooltip: 'Previous Page',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.all(6.r),
                      ),
                      SizedBox(width: 4.w),
                      // Next Page
                      IconButton(
                        onPressed: _currentPage < _pageCount
                            ? () => _pdfViewerController.nextPage()
                            : null,
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: _currentPage < _pageCount
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                        tooltip: 'Next Page',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.all(6.r),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
