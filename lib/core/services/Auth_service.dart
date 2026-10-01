import 'package:flutter_project_structure/core/logging/logger.dart';
import 'package:flutter_project_structure/route/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthService {
  AuthService._();

  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';
  static const String _userIdKey = 'user_id';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // In-memory cache for ultra-fast, synchronous access without await lag
  static String? _token;
  static String? _role;
  static String? _userId;
  static bool _isInitialized = false;

  /// Initialize and load persisted credentials into memory cache (call in main.dart)
  static Future<void> init() async {
    try {
      _token = await _storage.read(key: _tokenKey);
      _role = await _storage.read(key: _roleKey);
      _userId = await _storage.read(key: _userIdKey);
      _isInitialized = true;
      AppLogger.info('AuthService initialized securely.');
    } catch (e, stack) {
      AppLogger.error('Failed to initialize AuthService', e, stack);
    }
  }

  /// Synchronously checks if an auth token exists
  static bool hasToken() {
    return _token != null && _token!.trim().isNotEmpty;
  }

  /// Synchronous getter for the cached auth token
  static String? get token => _token;

  /// Synchronous getter for the user role
  static String? get role => _role;

  /// Synchronous getter for the user ID
  static String? get userId => _userId;

  /// Check whether AuthService has finished initializing
  static bool get isInitialized => _isInitialized;

  /// Save the token and optional user ID securely
  static Future<void> saveToken(String token, {String? id}) async {
    try {
      _token = token;
      await _storage.write(key: _tokenKey, value: token);

      if (id != null) {
        _userId = id;
        await _storage.write(key: _userIdKey, value: id);
      }
      AppLogger.info('Auth token saved securely.');
    } catch (e, stack) {
      AppLogger.error('Error saving auth token securely', e, stack);
    }
  }

  /// Save user role securely
  static Future<void> saveRole(String role) async {
    try {
      _role = role;
      await _storage.write(key: _roleKey, value: role);
      AppLogger.info('Role saved securely: $role');
    } catch (e, stack) {
      AppLogger.error('Error saving role securely', e, stack);
    }
  }

  /// Clear all credentials securely and navigate to login
  static Future<void> logoutUser() async {
    try {
      _token = null;
      _role = null;
      _userId = null;
      await _storage.deleteAll();
      AppLogger.info('Logout: Secure credentials cleared.');
      Get.offAllNamed(AppRoute.init);
    } catch (e, stack) {
      AppLogger.error('Error during logout', e, stack);
    }
  }

  /// Navigate to login screen
  static Future<void> goToLogin() async {
    Get.offAllNamed(AppRoute.init);
  }
}

