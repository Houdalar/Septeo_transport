import 'package:flutter/material.dart';
import '../view/components/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;
  final Map<String, String> headers;

  ApiService({
    this.baseUrl = "10.0.2.2:8080",
    this.headers = const {"Content-Type": "application/json; charset=UTF-8"},
  });

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.http(baseUrl, url),
      headers: headers,
      body: json.encode(body),
    );
    final result = _handleResponse(response);
    if (result != null) {
      return result;
    } else {
      throw ApiException(response.statusCode, "Null response received");
    }
  }

  Future<dynamic> get(String url) async {
    final response = await http.get(Uri.http(baseUrl, url));
    return _handleResponse(response);
  }

  Future<dynamic> delete(String url) async {
    final response = await http.delete(Uri.http(baseUrl, url));
    return _handleResponse(response);
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.http(baseUrl, url),
      headers: headers,
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var responseBody = json.decode(response.body);
      if (responseBody is Map || responseBody is List) {
        return responseBody;
      } else {
        throw ApiException(response.statusCode, "Unexpected response format");
      }
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }
}

void showdialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

class ApiException implements Exception {
  final int statusCode;
  final String responseBody;

  ApiException(this.statusCode, this.responseBody);

  @override
  String toString() {
    return 'ApiException: $statusCode $responseBody';
  }
}

class ErrorHandler {
  static void handleError(BuildContext context, ApiException exception) {
    String title = "Error";
    String message = ErrorHandler.getMessage(exception.statusCode);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(title,
                  style: const TextStyle(color: AppColors.primaryOrange)),
              content: Text(message,
                  style: const TextStyle(color: AppColors.primaryTextColor)));
        });
  }

  static String getMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return "Success";
      case 400:
        return "Wrong password.";
      case 401:
        return "The email address is not associated with any account. Please check and try again.";
      // Add more cases here for other status codes
      default:
        return "Something went wrong. Please try again later.";
    }
  }
}
