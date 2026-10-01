import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_project_structure/core/logging/logger.dart';
import 'package:flutter_project_structure/core/models/response_data.dart';
import 'package:flutter_project_structure/core/services/auth_service.dart';
import 'package:http/http.dart' as http;

class NetworkCaller {
  static const Duration _timeout = Duration(seconds: 30);

  Future<ResponseData> getRequest(
    String endpoint, {
    String? token,
    Map<String, String>? headers,
  }) async {
    AppLogger.info('🌐 GET Request: $endpoint');
    try {
      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: _buildHeaders(token: token, extraHeaders: headers),
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> postRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? headers,
  }) async {
    AppLogger.info('🚀 POST Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'POST Request');

    try {
      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: _buildHeaders(token: token, extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> putRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? headers,
  }) async {
    AppLogger.info('🔄 PUT Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'PUT Request');

    try {
      final response = await http
          .put(
            Uri.parse(endpoint),
            headers: _buildHeaders(token: token, extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> patchRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? headers,
  }) async {
    AppLogger.info('✏️ PATCH Request: $endpoint');
    if (body != null) AppLogger.json(body, tag: 'PATCH Request');

    try {
      final response = await http
          .patch(
            Uri.parse(endpoint),
            headers: _buildHeaders(token: token, extraHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(
    String endpoint, {
    String? token,
    Map<String, String>? headers,
  }) async {
    AppLogger.info('🗑️ DELETE Request: $endpoint');
    try {
      final response = await http
          .delete(
            Uri.parse(endpoint),
            headers: _buildHeaders(token: token, extraHeaders: headers),
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> multipartRequest(
    String endpoint, {
    String method = 'POST',
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
  }) async {
    AppLogger.info('📦 $method Multipart Request: $endpoint');
    try {
      final request = http.MultipartRequest(method, Uri.parse(endpoint));

      final requestHeaders = _buildHeaders(token: token, extraHeaders: headers)
        ..remove('Content-Type');
      request.headers.addAll(requestHeaders);

      if (fields != null) {
        fields.forEach((key, value) {
          if (value != null) {
            request.fields[key] = value is Map || value is List
                ? jsonEncode(value)
                : value.toString();
          }
        });
      }

      if (files != null) {
        for (final entry in files) {
          if (entry.value.existsSync()) {
            request.files.add(
              await http.MultipartFile.fromPath(entry.key, entry.value.path),
            );
          } else {
            AppLogger.warning(
              '⚠️ Multipart File not found: ${entry.value.path}',
            );
          }
        }
      }

      final streamedResponse = await request.send().timeout(_timeout * 2);
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> multipartPostRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
  }) {
    return multipartRequest(
      endpoint,
      method: 'POST',
      fields: fields,
      files: files,
      token: token,
      headers: headers,
    );
  }

  Future<ResponseData> multipartPatchRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
  }) {
    return multipartRequest(
      endpoint,
      method: 'PATCH',
      fields: fields,
      files: files,
      token: token,
      headers: headers,
    );
  }

  Future<ResponseData> multipartPutRequest(
    String endpoint, {
    Map<String, dynamic>? fields,
    List<MapEntry<String, File>>? files,
    String? token,
    Map<String, String>? headers,
  }) {
    return multipartRequest(
      endpoint,
      method: 'PUT',
      fields: fields,
      files: files,
      token: token,
      headers: headers,
    );
  }

  Map<String, String> _buildHeaders({
    String? token,
    Map<String, String>? extraHeaders,
  }) {
    final effectiveToken = token ?? AuthService.token;
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (effectiveToken != null && effectiveToken.trim().isNotEmpty) {
      headers['Authorization'] = effectiveToken.startsWith('Bearer ')
          ? effectiveToken
          : 'Bearer $effectiveToken';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  ResponseData _handleResponse(http.Response response) {
    final decoded = _safeDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      AppLogger.info(
        '✅ Response [${response.statusCode}]: ${response.request?.url ?? ''}',
      );
      return ResponseData.success(
        data: decoded,
        statusCode: response.statusCode,
        message: _extractSuccessMessage(decoded),
      );
    }

    if (response.statusCode == 401) {
      AppLogger.warning(
        '🔒 Response [401 Unauthorized]: ${response.request?.url ?? ''}',
      );
      return ResponseData.error(
        message: _extractErrorMessage(
          decoded,
          'Your session has expired. Please log in again.',
        ),
        statusCode: 401,
        data: decoded,
      );
    }

    if (response.statusCode == 403) {
      AppLogger.warning(
        '🚫 Response [403 Forbidden]: ${response.request?.url ?? ''}',
      );
      return ResponseData.error(
        message: _extractErrorMessage(
          decoded,
          'You do not have permission to access this resource.',
        ),
        statusCode: 403,
        data: decoded,
      );
    }

    AppLogger.error(
      '⚠️ Response [${response.statusCode}]: ${response.request?.url ?? ''}',
    );
    return ResponseData.error(
      message: _extractErrorMessage(
        decoded,
        'Request failed with status code ${response.statusCode}.',
      ),
      statusCode: response.statusCode,
      data: decoded,
    );
  }

  dynamic _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _extractErrorMessage(dynamic decoded, String defaultMessage) {
    if (decoded is Map) {
      if (decoded['message'] != null) return decoded['message'].toString();
      if (decoded['error'] != null) return decoded['error'].toString();
      if (decoded['errors'] != null) return decoded['errors'].toString();
    }
    return defaultMessage;
  }

  String _extractSuccessMessage(dynamic decoded) {
    if (decoded is Map && decoded['message'] != null) {
      return decoded['message'].toString();
    }
    return '';
  }

  ResponseData _handleError(dynamic error) {
    if (error is TimeoutException) {
      AppLogger.error('⏱️ ❌ Network Error (Timeout): $error');
      return ResponseData.error(
        message: 'Request timed out. Please check your internet connection.',
        statusCode: 408,
      );
    } else if (error is SocketException) {
      AppLogger.error('🔌 ❌ Network Error (No Internet): $error');
      return ResponseData.error(
        message: 'No internet connection. Please verify your network.',
        statusCode: 0,
      );
    } else if (error is http.ClientException) {
      AppLogger.error('📡 ❌ Network Error (Client Exception): $error');
      return ResponseData.error(
        message: 'Client communication error. Please try again.',
        statusCode: 500,
      );
    } else {
      AppLogger.error('💥 ❌ Network Error: $error');
      return ResponseData.error(
        message: 'An unexpected network error occurred. Please try again.',
        statusCode: 500,
      );
    }
  }
}

/*
================================================================================
💡 HOW TO USE NetworkCaller (DUMMY API EXAMPLES)
================================================================================

final networkCaller = NetworkCaller();

// -----------------------------------------------------------------------------
// 1️⃣ GET Request Example (Fetching data)
// -----------------------------------------------------------------------------
Future<void> fetchUserProfile() async {
  final response = await networkCaller.getRequest(
    'https://api.example.com/api/v1/user/profile',
  );

  if (response.isSuccess) {
    final userData = response.responseData;
    AppLogger.info('User Name: ${userData['data']['name']}');
  } else {
    AppLogger.error('Failed to load profile: ${response.errorMessage}');
  }
}

// -----------------------------------------------------------------------------
// 2️⃣ POST Request Example (Login / Create item)
// -----------------------------------------------------------------------------
Future<void> loginUser(String email, String password) async {
  final response = await networkCaller.postRequest(
    'https://api.example.com/api/v1/auth/login',
    body: {
      'email': email,
      'password': password,
    },
  );

  if (response.isSuccess) {
    final token = response.responseData['token'];
    await AuthService.saveToken(token);
  } else {
    AppLogger.error('Login error: ${response.errorMessage}');
  }
}

// -----------------------------------------------------------------------------
// 3️⃣ PUT Request Example (Full resource update)
// -----------------------------------------------------------------------------
Future<void> updateSettings(Map<String, dynamic> settingsData) async {
  final response = await networkCaller.putRequest(
    'https://api.example.com/api/v1/user/settings',
    body: settingsData,
  );

  if (response.isSuccess) {
    AppLogger.info('Settings updated successfully!');
  } else {
    AppLogger.error('Settings update failed: ${response.errorMessage}');
  }
}

// -----------------------------------------------------------------------------
// 4️⃣ PATCH Request Example (Partial update like bio or status)
// -----------------------------------------------------------------------------
Future<void> updateBio(String newBio) async {
  final response = await networkCaller.patchRequest(
    'https://api.example.com/api/v1/user/bio',
    body: {'bio': newBio},
  );

  if (response.isSuccess) {
    AppLogger.info('Bio updated successfully!');
  } else {
    AppLogger.error('Bio update failed: ${response.errorMessage}');
  }
}

// -----------------------------------------------------------------------------
// 5️⃣ DELETE Request Example (Removing an item)
// -----------------------------------------------------------------------------
Future<void> deletePost(String postId) async {
  final response = await networkCaller.deleteRequest(
    'https://api.example.com/api/v1/posts/$postId',
  );

  if (response.isSuccess) {
    AppLogger.info('Post deleted successfully!');
  } else {
    AppLogger.error('Delete failed: ${response.errorMessage}');
  }
}

// -----------------------------------------------------------------------------
// 6️⃣ Multipart POST Request (Upload new post with image)
// -----------------------------------------------------------------------------
Future<void> createPostWithImage(String caption, File imageFile) async {
  final response = await networkCaller.multipartPostRequest(
    'https://api.example.com/api/v1/posts/create',
    fields: {
      'caption': caption,
    },
    files: [
      MapEntry('image', imageFile),
    ],
  );

  if (response.isSuccess) {
    AppLogger.info('Post created with image!');
  } else {
    AppLogger.error('Upload failed: ${response.errorMessage}');
  }
}

// -----------------------------------------------------------------------------
// 7️⃣ Multipart PATCH Request (Update profile with optional new avatar)
// -----------------------------------------------------------------------------
Future<void> updateProfileWithPhoto(String name, File? newAvatar) async {
  final response = await networkCaller.multipartPatchRequest(
    'https://api.example.com/api/v1/user/profile',
    fields: {
      'name': name,
    },
    files: newAvatar != null 
        ? [MapEntry('avatar', newAvatar)] 
        : null,
  );

  if (response.isSuccess) {
    AppLogger.info('Profile and avatar updated!');
  } else {
    AppLogger.error('Profile update failed: ${response.errorMessage}');
  }
}
================================================================================
*/
