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
  static String baseUrl = "10.0.2.2:8080";
  //static String baseUrl = "192.168.250.165:8080";
  List<Planning> plannings = [];

  UserViewModel();

  static Future<void> login(
      String? email, String? password, BuildContext context) async {
    Map<String, dynamic> userData = {"email": email, "password": password};

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

        Navigator.pushReplacementNamed(context, '/home',
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

  static Future<List<Planning>> fetchPlannings(String user, DateTime date) async {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

  final response = await http.get(Uri.parse('http://$baseUrl/planning/$user/$formattedDate'));

  if (response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    List<Planning> plannings = List<Planning>.from(jsonResponse.map((model)=> Planning.fromJson(model)));
    return plannings;
  } else {
    throw Exception('Failed to load plannings');
  }
}

  Future<void> deletePlanning(String id) async {
    try {
      final response = await http.delete(Uri.parse('http://$baseUrl/planning/$id'));

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
  
}
