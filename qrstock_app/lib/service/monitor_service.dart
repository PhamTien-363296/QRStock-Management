import 'dart:convert';
import 'package:http/http.dart' as http;

class MonitorService {
  static const String baseUrl = "http://192.168.56.2:5000";



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