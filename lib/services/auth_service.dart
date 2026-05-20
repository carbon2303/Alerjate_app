import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String base = "https://alerjate-production.up.railway.app/api";

  Future<String?> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$base/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data["access_token"] != null) {
        return data["access_token"];
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
