import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'log_service.dart';

class AuthService {
  static const String baseUrl = "http://192.168.56.2:5000"; 

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data["token"]);
      LogService.info("JWT Saved: ${data["token"]}"); 
      return {"success": true, "token": data["token"]};  
    } else {
      final errorData = jsonDecode(response.body);
      LogService.error("Login failed: ${errorData["error"]}");
      return {"success": false, "error": errorData["error"] ?? "Login failed"};
    }
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwt_token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }
}
