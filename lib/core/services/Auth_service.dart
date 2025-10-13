import 'dart:developer';
import 'package:get/get.dart';
import 'package:multifix/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'token';

  static late SharedPreferences _preferences;

  static String? _token;
  static const String _roleKey = 'role';

  // Initialize SharedPreferences (call this during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    // Load token and userId from SharedPreferences into private variables
    _token = _preferences.getString(_tokenKey);
  }

  // Check if a token exists in local storage
  static bool hasToken() {
    return _preferences.containsKey(_tokenKey);
  }

  // Save the token and user ID to local storage
  static Future<void> saveToken(String token, {String? id}) async {
    try {
      await _preferences.setString(_tokenKey, token);
      // Update private variables
      _token = token;
    } catch (e) {
      log('Error saving token: $e');
    }
  }

  static bool _isInitialized = false;

  static Future<void> logoutUser() async {
    try {
      log('Logout called, _isInitialized: $_isInitialized');
      if (!_isInitialized) {
        log('Initializing SharedPreferences in logoutUser');
        _preferences = await SharedPreferences.getInstance();
        _isInitialized = true;
      }
      await _preferences.clear();
      _token = null;
      log('Logout cleared preferences');
      Get.offAllNamed(AppRoute.chooseRole);
    } catch (e) {
      log('Error during logout: $e');
    }
  }

  static Future<void> saveRole(String role) async {
    try {
      await _preferences.setString(_roleKey, role);
      log('Role saved: $role');
    } catch (e) {
      log('Error saving role: $e');
    }
  }

  static String? get role => _preferences.getString(_roleKey);

  static Future<void> goToLogin() async {
    Get.offAllNamed(AppRoute.loginScreen);
  }

  // Getter for token
  static String? get token => _token;
}