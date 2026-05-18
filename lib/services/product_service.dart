import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'https://alerjate-production.up.railway.app/api';

  Future<List<dynamic>> getProducts(String token) async {
    try {
      final url = Uri.parse('$baseUrl/products');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      print("Error products: ${response.body}");
      return [];
    } catch (e) {
      print("Exception products: $e");
      return [];
    }
  }
}
