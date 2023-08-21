import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final Preferences prefs;

  SessionManager({required this.prefs});

  Future<void> saveUserId(String id) async {
    await prefs.setString("userId", id);
  }

  Future<String?> getUserId() async {
    return await prefs.getString("userId");
  }

  Future<void> clearSession() async {
    await prefs.remove("userId");
    await prefs.remove("Role");
  }

  Future<void> saveRole(String role) async {
    await prefs.setString("Role", role);
  }

  Future<String?> getRole() async {
    return await prefs.getString("Role");
  }
}
abstract class Preferences {
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> remove(String key);
}
class SharedPreferencesImpl implements Preferences {
  @override
  Future<bool> setString(String key, String value) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.setString(key, value);
    });
  }

 @override
Future<String?> getString(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString(key);
    });
}

  @override
  Future<bool> remove(String key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.remove(key);
    });
  }
}

