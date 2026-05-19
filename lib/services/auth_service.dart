import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://alerjate-production.up.railway.app/api";

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),

        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },

        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data["access_token"];
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
