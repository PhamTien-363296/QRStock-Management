import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventoryService {
  static const String baseUrl = "http://192.168.56.2:5000";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }


  
static Future<Map<String, dynamic>> addInventory(
    String productId, String warehouseId, String locationId, int quantity, String batch, String expiryDate) async {
  
  final Uri url = Uri.parse("$baseUrl/api/inventory/add/$productId/$warehouseId/$locationId");
  final token = await _getToken();

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "quantity": quantity,
        "batch": batch,
        "expiry_date": expiryDate, 
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data["data"]["transaction"] == null || data["data"]["log"] == null) {
        return {"success": false, "error": "Transaction hoặc Log không được lưu!"};
      }

      return {"success": true, "data": data["data"]};
    } else {
      return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Lỗi khi thêm inventory"};
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối"};
  }
}


 
  static Future<Map<String, dynamic>> getInventoryInfo(String productId) async {
    final Uri url = Uri.parse("$baseUrl/api/inventory/get/information/$productId");
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
        return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Lỗi khi lấy thông tin tồn kho"};
      }
    } catch (e) {
      return {"success": false, "error": "Lỗi kết nối"};
    }
  }



}