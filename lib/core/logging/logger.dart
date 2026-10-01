import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLoggerHelper {
  AppLoggerHelper._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    // Disable console logging in release mode for security and performance
    level: kDebugMode ? Level.trace : Level.off,
  );

  /// Log at trace level
  static void trace(dynamic message) {
    _logger.t(message);
  }

  /// Log at debug level
  static void debug(dynamic message) {
    _logger.d(message);
  }

  /// Log at info level
  static void info(dynamic message) {
    _logger.i(message);
  }

  /// Log at warning level
  static void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log at error level with optional real [error] and [stackTrace]
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace ?? (error != null ? StackTrace.current : null),
    );
  }

  /// Log fatal crashes or critical issues
  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(
      message,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  /// Pretty-prints formatted JSON for API responses or complex maps
  static void json(dynamic data, {String? tag}) {
    if (!kDebugMode) return;
    try {
      final object = data is String ? jsonDecode(data) : data;
      final prettyString = const JsonEncoder.withIndent('  ').convert(object);
      _logger.d('${tag != null ? '[$tag]\n' : ''}$prettyString');
    } catch (_) {
      _logger.d('${tag != null ? '[$tag] ' : ''}$data');
    }
  }
}

/// Convenient shorter alias
typedef AppLogger = AppLoggerHelper;