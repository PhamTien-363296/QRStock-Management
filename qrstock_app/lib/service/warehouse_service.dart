import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseService {
  static const String baseUrl = "http://192.168.56.2:5000";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  static Future<Map<String, dynamic>> createWarehouse(String name, String location, int capacity) async {
  final Uri url = Uri.parse("$baseUrl/api/warehouse/create");
  final token = await _getToken();

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "location": location,
        "capacity": capacity,
      }),
    );

    if (response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    } else {
      return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Lỗi khi tạo warehouse"};
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối"};
  }
}

static Future<Map<String, dynamic>> getAllWarehouses() async {
  final Uri url = Uri.parse("$baseUrl/api/warehouse/get");
  final token = await _getToken();

  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return {"success": true, "data": jsonDecode(response.body)["data"]};
    } else {
      return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Lỗi khi lấy danh sách kho"};
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối"};
  }
}



}