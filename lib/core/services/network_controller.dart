import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_project_structure/core/logging/logger.dart';
import 'package:get/get.dart';

/// Global controller to monitor real-time network connectivity.

/// Features:
/// - Real-time stream listening via [Connectivity]
/// - Verification of real internet access via DNS lookup (avoids "Connected without Internet" false positives)
/// - Exposes reactive [isConnected] and [isChecking] observables
class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Observable indicating whether active internet connection is available.
  final RxBool isConnected = true.obs;

  /// Observable indicating if an explicit connection check is in progress.
  final RxBool isChecking = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChanged,
    );
  }

  Future<void> _initConnectivity() async {
    await checkConnection();
  }

  void _handleConnectivityChanged(List<ConnectivityResult> results) async {
    AppLogger.info('📡 Connectivity change detected: $results');

    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      isConnected.value = false;
      return;
    }

    // Verify real internet access
    final hasInternet = await _hasRealInternet();
    isConnected.value = hasInternet;
  }

  /// Explicitly check connectivity (useful for "Try Again" callbacks).
  Future<bool> checkConnection() async {
    isChecking.value = true;
    try {
      final results = await _connectivity.checkConnectivity();

      if (results.contains(ConnectivityResult.none) || results.isEmpty) {
        isConnected.value = false;
        return false;
      }

      final hasInternet = await _hasRealInternet();
      isConnected.value = hasInternet;
      return hasInternet;
    } catch (e) {
      AppLogger.error('❌ Error checking network connectivity: $e');
      isConnected.value = false;
      return false;
    } finally {
      isChecking.value = false;
    }
  }

  /// Pings google.com via DNS lookup to verify real internet reachability.
  Future<bool> _hasRealInternet() async {
    if (kIsWeb) {
      // Sockets not supported on web; rely on connectivity result
      return true;
    }

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 4));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
