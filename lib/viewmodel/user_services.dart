import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:septeo_transport/model/planning.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../constatns.dart';
import '../model/notification.dart';
import '../model/user.dart';
import '../session_manager.dart';

class UserViewModel extends ChangeNotifier {
  String? userId;
  List<Planning>? plannings;

  UserViewModel() {
    initUserId();
  }

  Future<void> initUserId() async {
    userId = SessionManager.userId;
  }

  // Login method
  Future<void> login(String email, String password, String regestrationtoken,
      BuildContext context) async {
    Map<String, dynamic> userdata = {
      "email": email,
      "password": password,
      "registrationToken": regestrationtoken
    };

    final response = await ApiService.post("/login", userdata);

    Map<String, dynamic> userData = json.decode(response.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", userData["token"]);

    String token = prefs.getString("token") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    await SessionManager.saveUserId(decodedToken["id"]);
    String userId = await SessionManager.getUserId();
    context.read<UserViewModel>().userId = userId;
    await SessionManager.saveRole(decodedToken["role"]);

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

    Navigator.pushReplacementNamed(context, '/home', arguments: role);
  }

  Future<List<User>> getDrivers() async {
    final response = await ApiService.get("/drivers");

    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => User.fromJson(item)).toList();
  }

  Future<Planning> getPlanning() async {
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }

    final response = await ApiService.get('/plannings/$userId');

    if (response.statusCode == 200) {
      return Planning.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load planning');
    }
  }

  Future<List<Planning>> getPlannings() async {
    await initUserId();
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }
    final response = await ApiService.get('/planning/$userId');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Planning.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load plannings');
    }
  }

  Future<Planning> addPlanning(
    String date,
    String fromStation,
    String toStation,
    String startBus,
    String finishBus,
    BuildContext context,
  ) async {
    Map<String, dynamic> planningData = {
      "user": userId,
      "date": date,
      "isTakingBus": "true",
      "fromStation": fromStation,
      "toStation": toStation,
      "startbus": startBus,
      "finishbus": finishBus,
    };

    final response = await ApiService.post("/planning", planningData);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return Planning.fromJson(responseBody);
    } else {
      throw Exception('Failed to add planning');
    }
  }

  Future<List<Planning>> fetchPlannings(String user, DateTime date) async {
    await initUserId();
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await ApiService.get('/planning/$userId/$formattedDate');

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      List<Planning> plannings = List<Planning>.from(
          jsonResponse.map((model) => Planning.fromJson(model)));
      return plannings;
    } else {
      throw Exception('Failed to load plannings');
    }
  }

  Future<void> deletePlanning(String id) async {
    final response = await ApiService.delete('planning/$id');

    if (response.statusCode == 200) {
      List<Planning> plannings = await getPlannings();
      plannings.removeWhere((planning) => planning.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete planning');
    }
  }

  Future<bool> updatePlanning(
    String id,
    String date,
    String fromStationId,
    String toStationId,
    String startBusId,
    String finishBusId,
  ) async {
    final Map<String, String> body = {
      'id': id,
      'date': date,
      'fromStation': fromStationId,
      'toStation': toStationId,
      'startbus': startBusId,
      'finishbus': finishBusId,
    };

    final response = await ApiService.put("/planning", body);

    return response.statusCode == 200;
  }

  Future<Planning?> getTodayPlanning() async {
    await initUserId();
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }

    final response = await ApiService.get('/todayplanning/$userId');
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Planning.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load planning');
    }
  }

  Future<List<User>> getUsers() async {
    final response = await ApiService.get('/users');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users from API');
    }
  }

  Future<User> getUser() async {
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }

    final response = await ApiService.get('/user/$userId');

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user from API');
    }
  }

  Future<User> createUser(
      String email, String password, String username, String role) async {
    final Map<String, String> body = {
      'email': email,
      'password': password,
      'username': username,
      'role': role,
    };

    final response = await ApiService.post("/user", body);

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await ApiService.delete('/user/$id');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<User> updateUser(String id, String email, String password,
      String username, String role) async {
    final Map<String, String?> body = {
      'email': email,
      'password': password,
      'username': username,
      'role': role,
    };

    final response = await ApiService.put("/user/$id", body);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user.');
    }
  }

  Future<void> sendMessage(String busId, String message) async {
    Map<String, dynamic> messageData = {"busId": busId, "message": message};

    final response = await ApiService.post("/message", messageData);

    if (response.statusCode != 200) {
      print('Failed to send message: ${response.statusCode}');
    }
  }

  Future<List<notification>> fetchNotifications() async {
    await initUserId();
    final response = await ApiService.get("/notifications/$userId");
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => notification.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
