import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:septeo_transport/model/planning.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../constatns.dart';
import '../model/notification.dart';
import '../model/user.dart';
import '../session_manager.dart';

class UserViewModel extends ChangeNotifier {
  String? userId;
  List<Planning>? plannings;
  final ApiService apiService;
  final SessionManager sessionManager;

  UserViewModel({required this.apiService, required this.sessionManager}) {
    initUserId();
  }

  Future<void> initUserId() async {
    userId = await sessionManager.getUserId();
  }

  // Login method
  Future<void> login(String email, String password, String regestrationtoken,
      BuildContext context) async {
    Map<String, dynamic> userdata = {
      "email": email,
      "password": password,
      "registrationToken": regestrationtoken
    };

    final response = await apiService.post("/login", userdata);
    Map<String, dynamic> userData = response;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(userData["token"]);
    await sessionManager.saveUserId(decodedToken["id"]);
    userId = await sessionManager.getUserId();
    await sessionManager.saveRole(decodedToken["role"]);

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
    final response = await apiService.get("/drivers");

    List jsonResponse = response;
    return jsonResponse.map((item) => User.fromJson(item)).toList();
  }


  Future<Planning> getPlanning() async {
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }

    final response = await apiService.get('/plannings/$userId');

    return Planning.fromJson(response);
  }


  Future<List<Planning>> getPlannings() async {
    await initUserId();
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }
    final response = await apiService.get('/planning/$userId');

    List jsonResponse = response;
    return jsonResponse.map((item) => Planning.fromJson(item)).toList();
  }


  Future<Planning> addPlanning({
    required String date,
    required String fromStation,
    required String toStation,
    required String startBus,
    required String finishBus,
  }) async {
    Map<String, dynamic> planningData = {
      "user": userId,
      "date": date,
      "isTakingBus": "true",
      "fromStation": fromStation,
      "toStation": toStation,
      "startbus": startBus,
      "finishbus": finishBus,
    };

    final responseBody = await apiService.post("/planning", planningData);
    return Planning.fromJson(responseBody);
  }

  Future<List<Planning>> fetchPlannings(String user, DateTime date) async {
    await initUserId();
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await apiService.get('/planning/$userId/$formattedDate');

    if (response is List) {
      return response.map((item) => Planning.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load plannings');
    }
  }

 Future<void> deletePlanning(String id) async {
    await apiService.delete('planning/$id');
    List<Planning> plannings = await getPlannings();
    plannings.removeWhere((planning) => planning.id == id);
    notifyListeners();
  }

 Future<bool> updatePlanning({
    required String id,
    required String date,
    required String fromStationId,
    required String toStationId,
    required String startBusId,
    required String finishBusId,
  }) async {
    final Map<String, String> body = {
      'id': id,
      'date': date,
      'fromStation': fromStationId,
      'toStation': toStationId,
      'startbus': startBusId,
      'finishbus': finishBusId,
    };

    final responseBody = await apiService.put("/planning", body);
    return responseBody != null;
  }

   Future<Planning?> getTodayPlanning() async {
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }

    final responseBody = await apiService.get('/todayplanning/$userId');
    return Planning.fromJson(responseBody);
  }

  Future<List<User>> getUsers() async {
    final responseBody = await apiService.get('/users');
    return responseBody.map((data) => User.fromJson(data)).toList();
  }

  Future<User> getUser() async {
    if (userId == null || userId!.isEmpty) {
      throw Exception('User is not logged in');
    }

    final responseBody = await apiService.get('/user/$userId');
    return User.fromJson(responseBody);
  }

 Future<User> createUser({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    final Map<String, String> body = {
      'email': email,
      'password': password,
      'username': username,
      'role': role,
    };

    final responseBody = await apiService.post("/user", body);
    return User.fromJson(responseBody);
  }

  Future<void> deleteUser(String id) async {
    await apiService.delete('/user/$id');
  }

  Future<User> updateUser({
    required String id,
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    final Map<String, String?> body = {
      'email': email,
      'password': password,
      'username': username,
      'role': role,
    };

    final responseBody = await apiService.put("/user/$id", body);
    return User.fromJson(responseBody);
  }

  Future<void> sendMessage({
    required String busId,
    required String message,
  }) async {
    Map<String, dynamic> messageData = {"busId": busId, "message": message};
    await apiService.post("/message", messageData);
  }

  Future<List<notification>> fetchNotifications() async {
    final responseBody = await apiService.get("/notifications/$userId");
    return responseBody.map((data) => notification.fromJson(data)).toList();
  }
}
