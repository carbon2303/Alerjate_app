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

  @override
  Widget build(BuildContext context) {
    final product = searchResult?["product"];

    final allergens = (product is Map && product["allergens"] is List)
        ? product["allergens"]
        : [];

    return Scaffold(
      // 🔥 DRAWER FUNCIONAL
      drawer: const AppDrawer(),

      backgroundColor: const Color(0xFFF5F7FA),

      // 🔥 APPBAR FIX DEFINITIVO ICONO
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
          ? const Center(child: CircularProgressIndicator())
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

                if (searching) const Center(child: CircularProgressIndicator()),

                // ================= SEMÁFORO =================
                if (product is Map)
                  SemaphoreBanner(status: product["status"] ?? "safe"),

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
                        Text("Categoría: ${product["category"] ?? ""}"),
                        const SizedBox(height: 10),
                        const Text(
                          "Alérgenos:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          spacing: 6,
                          children: allergens.map<Widget>((a) {
                            if (a is Map) {
                              return Chip(label: Text(a["name"] ?? ""));
                            }
                            return const SizedBox();
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Productos destacados",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                // ================= PRODUCTS =================
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
