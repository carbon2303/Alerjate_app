import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // =========================
  // GUARDAR TOKEN
  // =========================

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
  }

  // =========================
  // OBTENER TOKEN
  // =========================

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  // =========================
  // ELIMINAR TOKEN (LOGOUT)
  // =========================

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
  }
}
