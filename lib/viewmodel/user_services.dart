import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:septeo_transport/model/planning.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../model/user.dart';
import '../view/components/app_colors.dart';




class UserViewModel extends ChangeNotifier {
  //static String baseUrl = "10.0.2.2:8080";
  //static String baseUrl = "192.168.250.165:8080";
  
   static String baseUrl = "10.0.2.2:62668";
  List<Planning> plannings = [];

  UserViewModel();

  static Future<void> login(String? email, String? password,
      BuildContext context, String? token) async {
    String? token = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> userData = {
      "email": email,
      "password": password,
      "registrationToken": token, 
    };

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };

    http
        .post(Uri.http(baseUrl, "/login"),
            body: json.encode(userData), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", userData["token"]);

        String token = prefs.getString("token") ?? "";
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        Role role;
        switch (decodedToken['role']) {
          case 'Admin':
            role = Role.Admin;
            break;
          case 'Employee':
            role = Role.Employee;
            break;
          case 'Driver':
            role = Role.Driver;
            break;
          default:
            role = Role.Employee;
            break;
        }
        /*prefs.setString("userid", decodedToken["id"]);
        prefs.setString("username", decodedToken["username"]);
        prefs.setString("Role", role.toString()); 
        prefs.setString("email", decodedToken["email"]);*/

        Navigator.pushReplacementNamed(context, '/AppHome',
            arguments: decodedToken['role']);
      } else if (response.statusCode == 400) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  title: Text("Sign in failed",
                      style: TextStyle(color: AppColors.primaryOrange)),
                  content: Text("Wrong password",
                      style: TextStyle(color: AppColors.primaryTextColor)));
            });
      } else if (response.statusCode == 401) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  title: Text("Sign in failed",
                      style: TextStyle(color: AppColors.primaryOrange)),
                  content: Text(
                      "The email address is not associated with any account. please check and try again!",
                      style: TextStyle(color: AppColors.primaryTextColor)));
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  title: Text("Something went wrong",
                      style: TextStyle(color: AppColors.primaryOrange)),
                  content: Text("Something went wrong please try again later",
                      style: TextStyle(color: AppColors.primaryTextColor)));
            });
      }
    });
  }

  Future<List<User>> getDrivers() async {
    final response = await http.get(Uri.parse('http://$baseUrl/drivers'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load drivers');
    }
  }

  static Future<Planning> getPlanning(String id) async {
    final response = await http.get(Uri.parse('http://$baseUrl/plannings/$id'));

    if (response.statusCode == 200) {
      return Planning.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load planning');
    }
  }

  Future<List<Planning>> getPlannings() async {
    final response = await http.get(Uri.parse('http://$baseUrl/plannings'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Planning.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load plannings');
    }
  }

  static Future<Planning> addPlanning(
    String user,
    String date,
    String fromStation,
    String toStation,
    String startBus,
    String finishBus,
    BuildContext context,
  ) async {
    Map<String, dynamic> planningData = {
      "user": user,
      "date": date,
      "isTakingBus": "true",
      "fromStation": fromStation,
      "toStation": toStation,
      "startbus": startBus,
      "finishbus": finishBus,
    };

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };

    final response = await http.post(Uri.http(baseUrl, "/planning"),
        body: json.encode(planningData), headers: headers);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return Planning.fromJson(responseBody);
    } else {
      var error = json.decode(response.body)['msg'];
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Add planning failed",
                    style: TextStyle(color: AppColors.primaryOrange)),
                content: Text(error,
                    style: TextStyle(color: AppColors.primaryTextColor)));
          });
      throw Exception('Failed to add planning');
    }
  }

  static Future<List<Planning>> fetchPlannings(
      String user, DateTime date) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await http
        .get(Uri.parse('http://$baseUrl/planning/$user/$formattedDate'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Planning> plannings = List<Planning>.from(
          jsonResponse.map((model) => Planning.fromJson(model)));
      return plannings;
    } else {
      throw Exception('Failed to load plannings');
    }
  }

  Future<void> deletePlanning(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('http://$baseUrl/planning/$id'));

      if (response.statusCode == 200) {
        plannings.removeWhere((planning) => planning.id == id);
        notifyListeners();
      } else {
        // handling errors
        throw Exception('Failed to delete planning: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete planning: $e');
    }
  }

  static Future<bool> updatePlanning(
    String id,
    String date,
    String fromStationId,
    String toStationId,
    String startBusId,
    String finishBusId,
  ) async {
    final url = 'http://$baseUrl/planning';
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      // If needed add your auth headers
    };
    final Map<String, String> body = {
      'id': id,
      'date': date,
      'fromStation': fromStationId,
      'toStation': toStationId,
      'startbus': startBusId,
      'finishbus': finishBusId,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Planning?> getTodayPlanning(String id) async {
    var url = Uri.parse('http://$baseUrl/todayplanning/$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Planning.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load planning');
    }
  }

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('http://$baseUrl/users'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => User.fromJson(data)).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load users from API');
    }
  }

  static Future<User> getUser(String id) async {
    final response = await http.get(Uri.parse('http://$baseUrl/user/$id'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return User.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load user from API');
    }
  }

  static Future<User> createUser(
      String email, String password, String username, String role) async {
    final response = await http.post(
      Uri.parse('http://$baseUrl/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'username': username,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      // If the server returns a 201 response, parse the JSON.
      return User.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 201 response, throw an exception.
      throw Exception('Failed to create user.');
    }
  }

  static Future<void> deleteUser(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('http://$baseUrl/user/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user.');
    }
  }

  static Future<User> updateUser(String id, String email, String password,
      String username, String role) async {
    final response = await http.put(
      Uri.parse('http://$baseUrl/user/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'email': email,
        'password': password,
        'username': username,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return User.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to update user.');
    }
  }

  static Future<void> sendMessage(String busId, String message) async {
    Map<String, dynamic> messageData = {"busId": busId, "message": message};

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };

    http
        .post(Uri.http(baseUrl, "/message"),
            body: json.encode(messageData), headers: headers)
        .then((http.Response response) {
      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    });
  }
}
