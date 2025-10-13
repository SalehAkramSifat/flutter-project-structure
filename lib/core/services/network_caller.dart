import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_project_structure/core/logging/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/response_data.dart';
import 'auth_service.dart';

class NetworkCaller {
  final int timeoutDuration = 20;

  Future<ResponseData> getRequest(String endpoint, {String? token}) async {
    AppLoggerHelper.info('GET Request: $endpoint');
    try {
      final Response response = await get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? AuthService.token.toString(),
          'Content-type': 'text/plain',
          'x-api-key': "AABBCCCDDDJJKKIIUU1234",
        },
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> postRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('POST Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body.toString())}');

    try {
      final Response response = await post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? AuthService.token.toString(),
          'Content-type': 'application/json',
          'x-api-key': "AABBCCCDDDJJKKIIUU1234",
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> loginPostRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('POST Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body.toString())}');

    try {
      final Response response = await post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? AuthService.token.toString(),
          'Content-type': 'application/json',
          'x-api-key': "AABBCCCDDDJJKKIIUU1234",
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _loginhandleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> multipartRequest(
    String endpoint, {
    required List<File> files,
    required String field, // name of the file field, e.g., "tickets"
    String? token,
    Map<String, dynamic>? otherFields, // your text fields
  }) async {
    AppLoggerHelper.info('MULTIPART Request: $endpoint');
    try {
      final uri = Uri.parse(endpoint);
      final request = http.MultipartRequest('POST', uri);

      // Only Authorization header, remove manual Content-Type
      request.headers.addAll({
        'Authorization': token ?? AuthService.token.toString(),
      });

      // Add files
      for (final file in files) {
        request.files.add(await http.MultipartFile.fromPath(field, file.path));
      }

      // Add text fields
      if (otherFields != null) {
        final Map<String, String> fieldsAsString = {};
        otherFields.forEach((key, value) {
          // Convert value to JSON string if it's a Map
          if (value is Map || value is List) {
            fieldsAsString[key] = jsonEncode(value);
          } else {
            fieldsAsString[key] = value.toString();
          }
        });
        request.fields.addAll(fieldsAsString);
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60), // adjust timeoutDuration if needed
      );
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> multiPostRequest(
    String endpoint, {
    List<File>? images,
    File? invoice,
    String? token,
    Map<String, dynamic>? otherFields,
  }) async {
    AppLoggerHelper.info('MULTIPART Request: $endpoint');
    try {
      final uri = Uri.parse(endpoint);
      // ⚠️ Use PATCH instead of POST (as in Postman)
      final request = http.MultipartRequest('PATCH', uri);

      // Add headers
      request.headers.addAll({
        'Authorization': token ?? AuthService.token.toString(),
      });

      // Add bodyData as JSON string
      if (otherFields != null) {
        request.fields['bodyData'] = jsonEncode(otherFields);
      }

      // Add images (multiple)
      if (images != null && images.isNotEmpty) {
        for (final file in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images', file.path),
          );
        }
      }

      // Add invoice (single)
      if (invoice != null) {
        request.files.add(
          await http.MultipartFile.fromPath('invoice', invoice.path),
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> putRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('PUT Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body.toString())}');

    try {
      final Response response = await put(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? AuthService.token.toString(),
          'Content-type': 'application/json',
          'x-api-key': "AABBCCCDDDJJKKIIUU1234",
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> patchRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final authToken = token ?? AuthService.token ?? '';
    if (authToken == null || authToken.isEmpty) {
      return ResponseData(
        isSuccess: false,
        statusCode: 401,
        errorMessage: 'Missing or invalid authentication token.',
        responseData: null,
      );
    }

    AppLoggerHelper.info('PATCH Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');
    AppLoggerHelper.info('Token: $authToken');

    try {
      final Response response = await http
          .patch(
            Uri.parse(endpoint),
            headers: {
              'authorization': token ?? AuthService.token.toString(),
              'x-api-key': "AABBCCCDDDJJKKIIUU1234",
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> patchRequestWithImage(
    String endpoint, {
    Map<String, dynamic>? fields,
    String? imagePath,
    String? token,
  }) async {
    AppLoggerHelper.info('PATCH Multipart Request: $endpoint');
    AppLoggerHelper.info('Fields: ${jsonEncode(fields)}');
    AppLoggerHelper.info('Image Path: $imagePath');

    try {
      var request = http.MultipartRequest('PATCH', Uri.parse(endpoint));

      // Add individual fields
      if (fields != null) {
        fields.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      // Add image file if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            imagePath,
          ), // match server field
        );
      }

      // Add headers (no Content-Type)
      request.headers.addAll({
        'Authorization': token ?? AuthService.token.toString(),
        'x-api-key': "AABBCCCDDDJJKKIIUU1234",
      });

      // Send request
      http.StreamedResponse streamedResponse = await request.send().timeout(
        Duration(seconds: timeoutDuration),
      );

      final responseString = await streamedResponse.stream.bytesToString();
      final response = http.Response(
        responseString,
        streamedResponse.statusCode,
        headers: streamedResponse.headers,
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(String endpoint, String? token) async {
    AppLoggerHelper.info('DELETE Request: $endpoint');
    try {
      final Response response = await delete(
        Uri.parse(endpoint),
        headers: {
          'authorization': token ?? AuthService.token.toString(),
          'Content-type': 'application/json',
          'x-api-key': "AABBCCCDDDJJKKIIUU1234",
        },
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Handle the response from the server
  Future<ResponseData> _handleResponse(http.Response response) async {
    AppLoggerHelper.info('Response Status: ${response.statusCode}');
    AppLoggerHelper.info('Response Body: ${response.body}');

    try {
      final decodedResponse = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
        case 201:
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodedResponse,
            errorMessage: '',
          );
        case 204:
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: '',
          );
        case 400:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage:
                decodedResponse['message'] ??
                'There was an issue with your request. Please try again.',
            responseData: decodedResponse,
          );
        case 401:
          // await AuthService.logoutUser();
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'You are not authorized. Please log in to continue.',
            responseData: null,
          );
        case 403:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'You do not have permission to access this resource.',
            responseData: null,
          );
        case 404:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'The resource you are looking for was not found.',
            responseData: null,
          );
        case 500:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'Internal server error. Please try again later.',
            responseData: null,
          );
        default:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage:
                decodedResponse['message'] ??
                'Something went wrong. Please try again.',
            responseData: decodedResponse,
          );
      }
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Failed to process the response. Please try again later.',
        responseData: null,
      );
    }
  }

  ResponseData _loginhandleResponse(Response response) {
    log('Response Status: ${response.statusCode}');
    log('Response Body: ${response.body}');

    final decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decodedResponse['success'] == true) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse['result'],
          errorMessage: '',
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedResponse,
          errorMessage: decodedResponse['message'] ?? 'Unknown error occurred',
        );
      }
    }
    // else if (response.statusCode == 401) {
    //   return ResponseData(
    //     isSuccess: false,
    //     statusCode: response.statusCode,
    //     responseData: decodedResponse,
    //     errorMessage: _extractErrorMessages(decodedResponse['errorSources']),
    //   );
    // }
    else if (response.statusCode == 500) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage:
            decodedResponse['message'] ?? 'An unexpected error occurred!',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: decodedResponse['message'] ?? 'An unknown error occurred',
      );
    }
  }

  // Handle errors during the request process
  ResponseData _handleError(dynamic error) {
    log('Request Error: $error');

    if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        errorMessage:
            'Request timed out. Please check your internet connection and try again.',
        responseData: null,
      );
    } else if (error is http.ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage:
            'Network error occurred. Please check your connection and try again.',
        responseData: null,
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Unexpected error occurred. Please try again later.',
        responseData: null,
      );
    }
  }
}