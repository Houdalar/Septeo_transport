import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../model/user.dart';
import '../view/components/app_colors.dart';

class UserViewModel extends ChangeNotifier {
  static String baseUrl = "10.0.2.2:8080";

  UserViewModel();

  static Future<void> login(String? email, String? password,
      BuildContext context) async {
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
        switch(decodedToken['role']) {
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
        prefs.setString("userid", decodedToken["id"]);
        prefs.setString("username", decodedToken["username"]);
        prefs.setString("Role", role.toString()); 
        prefs.setString("email", decodedToken["email"]);

        Navigator.pushReplacementNamed(context, '/home');

      } else if (response.statusCode == 400) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  title: Text("Sign in failed",
                      style: TextStyle(color: AppColors.primaryOrange)),
                  content: Text("Wrong password", style: TextStyle(color: AppColors.primaryTextColor)));
            });
      } else if (response.statusCode == 401) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  title: Text("Sign in failed",
                      style: TextStyle(color: AppColors.primaryOrange)),
                  content: Text(
                      "The email address is not associated with any account. please check and try again!", style: TextStyle(color: AppColors.primaryTextColor)));
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  title: Text("Something went wrong",
                      style: TextStyle(color: AppColors.primaryOrange)),
                  content: Text(
                      "Something went wrong please try again later", style: TextStyle(color: AppColors.primaryTextColor)));
            });
      }
    });
  }

 
  }