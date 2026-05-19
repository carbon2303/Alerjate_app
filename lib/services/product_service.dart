import 'dart:convert';
import 'package:http/http.dart' as http;

import 'local_storage.dart';

class ProductService {
  final String baseUrl = 'https://alerjate-production.up.railway.app/api';

  // =========================
  // OBTENER PRODUCTOS
  // =========================

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

  // =========================
  // BÚSQUEDA INTELIGENTE
  // =========================

  Future<Map<String, dynamic>?> searchProduct(String query) async {
    try {
      final token = await LocalStorage.getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/search'),

        headers: {
          'Content-Type': 'application/json',

          'Accept': 'application/json',

          'Authorization': 'Bearer $token',
        },

        body: jsonEncode({'query': query}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      print("Error search: ${response.body}");

      return null;
    } catch (e) {
      print("Exception search: $e");

      return null;
    }
  }

  // =========================
  // FILTRO POR CATEGORÍA
  // =========================

  Future<List<dynamic>> getProductsByCategory(String category) async {
    try {
      final token = await LocalStorage.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/products?category=$category'),

        headers: {
          'Accept': 'application/json',

          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return [];
    } catch (e) {
      print(e);

      return [];
    }
  }
}
