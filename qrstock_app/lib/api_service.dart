import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://192.168.56.2:5000";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

 
  static Future<Map<String, dynamic>> signUp(String username, String email, String password) async {
    final Uri url = Uri.parse("$baseUrl/api/auth/signup");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Đăng ký thất bại"};
      }
    } catch (e) {
      return {"success": false, "error": "Lỗi kết nối"};
    }
  }

 
  static Future<Map<String, dynamic>> createProduct(String name, String description) async {
    final Uri url = Uri.parse("$baseUrl/api/product/create");
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
        return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Tạo sản phẩm thất bại"};
      }
    } catch (e) {
      return {"success": false, "error": "Lỗi kết nối"};
    }
  }

  
  static Future<Map<String, dynamic>> getProducts() async {
    final Uri url = Uri.parse("$baseUrl/api/product/get");
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
        return {"success": false, "error": "Lỗi khi lấy sản phẩm"};
      }
    } catch (e) {
      return {"success": false, "error": "Lỗi kết nối"};
    }
  }

  
  static Future<Map<String, dynamic>> addInventory(String productId, int quantity, String location) async {
    final Uri url = Uri.parse("$baseUrl/api/inventory/add/$productId");
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
          "location": location,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["data"]["transaction"] == null) {
          return {"success": false, "error": "Transaction không được lưu!"};
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

  static Future<Map<String, dynamic>> getTransactions() async {
  final Uri url = Uri.parse("$baseUrl/api/transaction/get");

  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return {"success": true, "data": jsonDecode(response.body)["data"]};
    } else {
      return {"success": false, "error": jsonDecode(response.body)["error"] ?? "Lỗi khi lấy danh sách giao dịch"};
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối"};
  }
}

static Future<Map<String, dynamic>> getLogs() async {
  final Uri url = Uri.parse("$baseUrl/api/log/get");

  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<dynamic> logs = responseBody["data"] ?? []; 

      return {"success": true, "data": logs};
    } else {
      return {
        "success": false,
        "error": jsonDecode(response.body)["error"] ?? "Lỗi khi lấy danh sách log"
      };
    }
  } catch (e) {
    return {"success": false, "error": "Lỗi kết nối"};
  }
}


}
