import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String baseUrl = "http://192.168.56.2:5000";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }


static Future<Map<String, dynamic>> createLocation(
    String warehouseId, String shelf, String bin, int maxCapacity) async {
  final Uri url = Uri.parse("$baseUrl/api/location/create/$warehouseId");
  final token = await _getToken();

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "shelf": shelf,
        "bin": bin,
        "max_capacity": maxCapacity,
      }),
    );

    if (response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    } else {
      return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Lỗi khi thêm location"};
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối"};
  }
}

static Future<Map<String, dynamic>> getLocationsByWarehouseId(String warehouseId) async {
  final Uri url = Uri.parse("$baseUrl/api/location/get/$warehouseId");
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
      return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Lỗi khi lấy danh sách location"};
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối"};
  }
}

}