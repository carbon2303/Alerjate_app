import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/type_fix.dart';

class AllergenService {
  static const base = "https://alerjate-production.up.railway.app/api";

  static Future<List<dynamic>> getAllergens(String token) async {
    final res = await http.get(
      Uri.parse("$base/allergens"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body);
  }

  static Future<List<int>> getUserAllergens(String token) async {
    final res = await http.get(
      Uri.parse("$base/user/allergens"),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(res.body);

    if (data is List) {
      return data.map<int>((e) => toInt(e)).toList();
    }

    if (data["allergens"] != null) {
      return (data["allergens"] as List)
          .map<int>((e) => toInt(e["id"] ?? e))
          .toList();
    }

    return [];
  }

  static Future<bool> saveUserAllergens(String token, List<int> ids) async {
    final res = await http.post(
      Uri.parse("$base/user/allergens"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"allergen_ids": ids}),
    );

    return res.statusCode == 200;
  }
}
