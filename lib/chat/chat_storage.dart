import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_message.dart';

class ChatStorage {
  static const String key = "chat_messages";

  static Future<void> save(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();

    final data = messages.map((e) => e.toJson()).toList();

    prefs.setString(key, jsonEncode(data));
  }

  static Future<List<ChatMessage>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);

    return decoded.map((e) => ChatMessage.fromJson(e)).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
