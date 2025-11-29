import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoaderHelper {
  static bool _isLoaderOpen = false;
  static int _loaderCount = 0;

  static Future<T> showLoader<T>(
    Future<T> Function() action, {
    Widget? loadingWidget,
    bool barrierDismissible = false,
    Duration minDisplayTime = const Duration(milliseconds: 300),
    String? loadingText,
    VoidCallback? onTimeout,
    Duration? timeoutDuration,
  }) async {
    final startTime = DateTime.now();
    bool loaderShown = false;

    try {
      // Only show loader if one isn't already visible
      if (!_isLoaderOpen) {
        _isLoaderOpen = true;
        loaderShown = true;

        // Check if dialog is already open
        final isDialogCurrentlyOpen = Get.isDialogOpen ?? false;

        if (!isDialogCurrentlyOpen) {
          Get.dialog(
            PopScope(
              canPop: barrierDismissible,
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: _buildLoadingContent(loadingWidget, loadingText),
              ),
            ),
            barrierDismissible: barrierDismissible,
            barrierColor: Colors.black54,
          );

          // Small delay to ensure dialog is built
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      _loaderCount++;

      // Execute action with optional timeout
      final T result;
      if (timeoutDuration != null) {
        result = await action().timeout(
          timeoutDuration,
          onTimeout: () {
            onTimeout?.call();
            throw TimeoutException(
              'Operation timed out after ${timeoutDuration.inSeconds}s',
            );
          },
        );
      } else {
        result = await action();
      }

      // Ensure minimum display time for smooth UX
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < minDisplayTime) {
        await Future.delayed(minDisplayTime - elapsed);
      }

      return result;
    } catch (e) {
      // Ensure minimum display time even on error
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < minDisplayTime) {
        await Future.delayed(minDisplayTime - elapsed);
      }
      rethrow;
    } finally {
      _loaderCount--;

      // Only close loader when all nested calls complete
      if (_loaderCount <= 0 && loaderShown) {
        _loaderCount = 0;
        _closeLoader();
      }
    }
  }

  /// Builds the loading content widget
  static Widget _buildLoadingContent(Widget? customWidget, String? text) {
    if (customWidget != null) {
      return customWidget;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpinKitCircle(color: Colors.blue, size: 50),
          if (text != null) ...[
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Safely closes the loader dialog
  static void _closeLoader() {
    try {
      if (_isLoaderOpen && (Get.isDialogOpen ?? false)) {
        Get.back();
      }
    } catch (e) {
      debugPrint('Error closing loader: $e');
    } finally {
      _isLoaderOpen = false;
    }
  }

  /// Force close all loaders (use with caution)
  static void forceClose() {
    _loaderCount = 0;
    _closeLoader();
  }

  /// Check if loader is currently showing
  static bool get isLoading => _isLoaderOpen;
}

/// Custom exception for timeout scenarios
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
