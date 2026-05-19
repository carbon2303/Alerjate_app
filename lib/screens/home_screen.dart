import 'package:flutter/material.dart';

import '../services/product_service.dart';
import '../services/local_storage.dart';
import '../services/image_service.dart';

import '../widgets/product_card.dart';
import '../widgets/semaphore_banner.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _service = ProductService();

  List<Map<String, dynamic>> products = [];

  bool loading = true;
  bool searching = false;

  Map<String, dynamic>? searchResult;

  final TextEditingController searchController = TextEditingController();

  // ================= CHATBOT =================

  final TextEditingController _chatController = TextEditingController();

  String _chatResponse = "Haz una pregunta al asistente IA...";

  bool _isChatLoading = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
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

  // ================= CHATBOT =================

  Future<void> _sendChatMessage() async {
    final message = _chatController.text.trim();

    if (message.isEmpty) return;

    setState(() {
      _isChatLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _chatResponse = "Respuesta del chatbot para: $message";

      _isChatLoading = false;
    });
  }

  // ===========================================

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
        backgroundColor: const Color(0xFF5CC5DF),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: const Text(
          "ALERJATE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                // ================= HERO =================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5CC5DF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.health_and_safety,
                        size: 80,
                        color: Colors.white,
                      ),
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

                // ================= SEARCH =================

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Buscar producto...",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: searchProduct,
                        child: const Text("Buscar"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                if (searching)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                // ================= SEMAFORO =================

                if (product is Map)
                  SemaphoreBanner(
                    status: product["status"] ?? "safe",
                  ),

                const SizedBox(height: 10),

                // ================= RESULTADO =================

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
                        Text(
                          product["name"] ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Categoría: ${product["category"] ?? ""}",
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Alérgenos:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Wrap(
                          spacing: 6,
                          children: allergens.map<Widget>((a) {
                            if (a is Map) {
                              return Chip(
                                label: Text(a["name"] ?? ""),
                              );
                            }

                            return const SizedBox();
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                // ================= CHATBOT =================

                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.purple.shade900,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "🤖 Asistente Médico IA",
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Alerjate-Bot responderá tus preguntas.",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _chatController,
                                decoration: const InputDecoration(
                                  hintText: 'Ej: ¿Puedo comer chocolate?',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                              ),
                              onPressed:
                                  _isChatLoading ? null : _sendChatMessage,
                              child: _isChatLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "PREGUNTAR",
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _chatResponse,
                            style: TextStyle(
                              fontSize: 13,
                              color: _isChatLoading
                                  ? Colors.purpleAccent
                                  : Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= PRODUCTS =================

                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Productos destacados",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ...products.map((item) {
                  return ProductCard(
                    name: item['name'] ?? '',
                    description: item['description'] ?? '',
                    image: ImageService.getImage(item['name'] ?? ''),
                    safe: item['safe'] ?? true,
                  );
                }).toList(),

                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
