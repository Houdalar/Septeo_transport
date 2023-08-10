import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static  String userId = "";
  static  String Role = "Admin";
  static Future<void> saveUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", id);
    userId = id;
    
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
    return userId;
}

  static Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = "";
    Role = "";
    prefs.remove("userId");
    prefs.remove("Role");
  }

  static Future<void> saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Role", role);
    Role = role;
  }
 
}
