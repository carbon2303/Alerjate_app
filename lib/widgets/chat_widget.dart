import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/local_storage.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  bool open = false;

  final List<Map<String, dynamic>> messages = [];
  final TextEditingController controller = TextEditingController();

  final String apiBase = "https://alerjate-production.up.railway.app/api";

  void toggle() {
    setState(() => open = !open);
  }

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    controller.clear();

    setState(() {
      messages.add({"user": true, "text": text});
      messages.add({"loading": true});
    });

    final token = await LocalStorage.getToken();

    final res = await http.post(
      Uri.parse("$apiBase/chatbot"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"message": text}),
    );

    final data = jsonDecode(res.body);

    setState(() {
      messages.removeWhere((m) => m["loading"] == true);

      messages.add({"user": false, "text": data["reply"] ?? "Sin respuesta"});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 💬 BOTÓN (fixed real)
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF0777B5),
            onPressed: toggle,
            child: const Icon(Icons.chat),
          ),
        ),

        // 💬 VENTANA FLOTANTE
        if (open)
          Positioned(
            bottom: 90,
            right: 20,
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 360,
                height: 520, // 🔥 CLAVE PARA QUE NO SE CORTE
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // HEADER
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5CC5DF),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Alerjate Bot",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: toggle,
                          )
                        ],
                      ),
                    ),

                    // CHAT BODY
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (context, i) {
                          final m = messages[i];

                          if (m["loading"] == true) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Analizando... ✍️"),
                            );
                          }

                          final isUser = m["user"] == true;

                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? const Color(0xFF0777B5)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                m["text"] ?? "",
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // INPUT
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: controller,
                            onSubmitted: (_) => send(),
                            textInputAction: TextInputAction.send,
                            decoration: const InputDecoration(
                              hintText: "Escribe...",
                            ),
                          )),
                          IconButton(
                            onPressed: send,
                            icon: const Icon(Icons.send),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
