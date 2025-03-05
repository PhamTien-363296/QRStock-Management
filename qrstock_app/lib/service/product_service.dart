import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  static const String baseUrl = "http://192.168.56.2:5000";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }


   
  static Future<Map<String, dynamic>> createProduct(
  String warehouseId,
  String locationId,
  String name,
  String description,
) async {
  final Uri url = Uri.parse("$baseUrl/api/product/create/$warehouseId/$locationId");
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
        "description": description,
      }),
    );

    if (response.statusCode == 201) {
      return {"success": true, "data": jsonDecode(response.body)};
    } else {
      return {
        "success": false,
        "error": jsonDecode(response.body)["message"] ?? "Tạo sản phẩm thất bại"
      };
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối: $e"};
  }
}



  static Future<Map<String, dynamic>> getProductsByWarehouseAndLocation(
    String warehouseId, String locationId) async {
  final Uri url = Uri.parse("$baseUrl/api/product/get/$warehouseId/$locationId");
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
      return {"success": true, "data": jsonDecode(response.body)["products"]};
    } else {
      return {
        "success": false,
        "error": jsonDecode(response.body)["message"] ?? "Lỗi khi lấy danh sách sản phẩm"
      };
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối: $e"};
  }
}


}