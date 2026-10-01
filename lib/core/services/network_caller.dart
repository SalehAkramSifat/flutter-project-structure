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
