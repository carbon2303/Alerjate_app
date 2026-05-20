import 'dart:convert';
import 'package:http/http.dart' as http;

import '../chat/chat_message.dart';

class AIService {
  static const String apiKey = "https://alerjate-production.up.railway.app/api";

  static Future<String> sendMessage(List<ChatMessage> messages) async {
    final url = Uri.parse(
      "https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2",
    );

    // Convertimos historial a texto simple
    final prompt = messages.map((m) {
      return m.isUser ? "Usuario: ${m.text}" : "IA: ${m.text}";
    }).join("\n");

    final body = {
      "inputs": """
Eres un asistente experto en alergias alimentarias.

Conversación:
$prompt

IA:"""
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // HuggingFace devuelve lista
      if (data is List && data.isNotEmpty) {
        return data[0]["generated_text"].toString().split("IA:").last.trim();
      }

      return "Sin respuesta de IA";
    }

    return "Error HF: ${response.body}";
  }
}
