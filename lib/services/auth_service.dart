import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');
    return username == savedUsername && password == savedPassword;
  }
}
