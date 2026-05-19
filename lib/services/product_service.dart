import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local_storage.dart';

class ProductService {
  final String baseUrl = 'https://alerjate-production.up.railway.app/api';

  Future<List<dynamic>> getProducts(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) return [];

    final data = jsonDecode(res.body);

    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'];

    return [];
  }

  Future<Map<String, dynamic>?> searchProduct(String query) async {
    final token = await LocalStorage.getToken();

    final res = await http.post(
      Uri.parse('$baseUrl/search'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'query': query}),
    );

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);

    if (data is Map<String, dynamic>) return data;

    return null;
  }
}
