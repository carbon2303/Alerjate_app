import 'package:flutter/material.dart';

import '../services/product_service.dart';
import '../services/local_storage.dart';
import '../services/image_service.dart';
import '../services/ai_service.dart';

import '../widgets/product_card.dart';
import '../widgets/semaphore_banner.dart';
import '../widgets/app_drawer.dart';

import '../chat/chat_message.dart';
import '../chat/chat_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _service = ProductService();

  // ================= PRODUCTS =================
  List<Map<String, dynamic>> products = [];
  bool loading = true;
  bool searching = false;
  Map<String, dynamic>? searchResult;

  final TextEditingController searchController = TextEditingController();

  // ================= CHAT =================
  List<ChatMessage> messages = [];
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isChatLoading = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadChat();
  }

  Future<void> loadProducts() async {
    final token = await LocalStorage.getToken();

    if (token == null) {
      setState(() => loading = false);
      return;
    }

    final data = await _service.getProducts(token);

    setState(() {
      products = List<Map<String, dynamic>>.from(data);
      loading = false;
    });
  }

  Future<void> loadChat() async {
    final data = await ChatStorage.load();
    setState(() => messages = data);
  }

  // ================= SEARCH =================
  Future<void> searchProduct() async {
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      searching = true;
      searchResult = null;
    });

    final data = await _service.searchProduct(query);

    setState(() {
      searchResult = (data is Map<String, dynamic>) ? data : null;
      searching = false;
    });
  }

  // ================= SEND MESSAGE =================
  Future<void> sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text: text, isUser: true));
      _isChatLoading = true;
    });

    _chatController.clear();
    await ChatStorage.save(messages);
    _scrollToBottom();

    try {
      final response = await AIService.sendMessage(messages);

      setState(() {
        messages.add(ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      setState(() {
        messages.add(ChatMessage(
          text: "Error al conectar con la IA 😢",
          isUser: false,
        ));
      });
    }

    setState(() => _isChatLoading = false);

    await ChatStorage.save(messages);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ================= CHAT SHEET =================
  Widget _buildChatSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 10),

          const ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 63, 201, 255),
              child: Icon(Icons.smart_toy, color: Colors.white),
            ),
            title: Text("Alerjate AI"),
            subtitle: Text("Asistente inteligente"),
          ),

          const Divider(),

          // ================= CHAT LIST =================
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];

                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? const Color.fromARGB(255, 61, 213, 255)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isChatLoading)
            const Padding(
              padding: EdgeInsets.all(6),
              child: Text("IA escribiendo..."),
            ),

          // ================= INPUT =================
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: const InputDecoration(
                      hintText: "Escribe un mensaje...",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: const Color.fromARGB(255, 67, 205, 255),
                  onPressed: sendMessage,
                  child: const Icon(Icons.send, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = searchResult?["product"];

    final allergens = (product is Map && product["allergens"] is List)
        ? product["allergens"]
        : [];

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 156, 255),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "ALERJATE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // HERO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 14, 121),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.health_and_safety,
                          size: 80, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "Encuentra productos seguros",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SEARCH
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: "Buscar producto...",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: searchProduct,
                        child: const Text("Buscar"),
                      )
                    ],
                  ),
                ),

                if (searching) const Center(child: CircularProgressIndicator()),

                // SEMÁFORO
                if (product is Map)
                  SemaphoreBanner(
                    status: product["status"] ?? "safe",
                  ),

                const SizedBox(height: 10),

                // RESULTADO
                if (product is Map)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product["name"] ?? "",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Categoría: ${product["category"] ?? ""}"),
                        const SizedBox(height: 10),
                        const Text("Alérgenos:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 6,
                          children: allergens.map<Widget>((a) {
                            if (a is Map) {
                              return Chip(
                                label: Text(a["name"] ?? ""),
                                backgroundColor: Colors.red.shade50,
                              );
                            }
                            return const SizedBox();
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // PRODUCTS
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Productos destacados",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                ...products.map((item) {
                  return ProductCard(
                    name: item['name'] ?? '',
                    description: item['description'] ?? '',
                    image: ImageService.getImage(item['name'] ?? ''),
                    safe: item['safe'] ?? true,
                  );
                }),

                const SizedBox(height: 120),
              ],
            ),

      // ================= FLOATING CHAT =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 1, 0, 69),
        child: const Icon(Icons.chat, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildChatSheet(),
          );
        },
      ),
    );
  }
}
