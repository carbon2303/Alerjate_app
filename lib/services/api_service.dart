import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const base = "https://alerjate-production.up.railway.app/api";

  // LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final res = await http.post(
      Uri.parse("$base/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(res.body);
  }

  // PRODUCTS
  static Future<List<dynamic>> getProducts(String query) async {
    final res = await http.get(Uri.parse("$base/products?$query"));
    final data = jsonDecode(res.body);

    if (data is List) return data;
    if (data["products"] != null) return data["products"];

    return [];
  }

  // SEARCH
  static Future<List<dynamic>> search(String q) async {
    final res = await http.post(
      Uri.parse("$base/search"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": q}),
    );

    final data = jsonDecode(res.body);
    return data["products"] ?? [];
  }

  // CHATBOT
  static Future<Map<String, dynamic>> chat(String message, String token) async {
    final res = await http.post(
      Uri.parse("$base/chatbot"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"message": message}),
    );

    return jsonDecode(res.body);
  }
}
