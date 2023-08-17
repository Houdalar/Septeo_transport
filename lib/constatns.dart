import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/viewmodel/user_services.dart';
import '../view/components/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "10.0.2.2:8080";
  static const Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  static Future<http.Response> post(
      String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.http(baseUrl, url),
      headers: headers,
      body: json.encode(body),
    );
    _handleError(response);
    return response;
  }

  static Future<http.Response> get(String url) async {
    final response = await http.get(Uri.http(baseUrl, url));
    _handleError(response);
    return response;
  }

  static Future<http.Response> delete(String url) async {
    final response = await http.delete(Uri.http(baseUrl, url));
    _handleError(response);
    return response;
  }

  static Future<http.Response> put(
      String url, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.http(baseUrl, url),
      headers: headers,
      body: json.encode(body),
    );
    _handleError(response);
    return response;
  }

  static void _handleError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed with status code: ${response.statusCode} ${response.body}}');
    }
  }
}

class ErrorHandler {
  static void handleError(BuildContext context, int statusCode) {
    String title = "Error";
    String message = "Something went wrong. Please try again later.";

    switch (statusCode) {
      case 200:
        message = "Success";
        break;
      case 400:
        message = "Wrong password.";
        break;
      case 401:
        message =
            "The email address is not associated with any account. Please check and try again.";
        break;
      // Add more cases here for other status codes
      default:
        message = "Something went wrong. Please try again later.";
        break;
    }

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
}
