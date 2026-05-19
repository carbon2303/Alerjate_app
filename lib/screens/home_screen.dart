import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/local_storage.dart';
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
    if (token == null) return;

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
      searchResult = data;
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
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("ALERJATE"),
        backgroundColor: const Color(0xFF5CC5DF),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // BUSCADOR
                  Padding(
                    padding: const EdgeInsets.all(16),
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
                        ),
                      ],
                    ),
                  ),

                  if (searching) const CircularProgressIndicator(),

                  // SEMÁFORO
                  if (product is Map)
                    SemaphoreBanner(status: product["status"] ?? "safe"),

                  // RESULTADO
                  if (product is Map)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product["name"] ?? "",
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text("Categoría: ${product["category"] ?? ""}"),
                          const SizedBox(height: 10),
                          const Text("Alérgenos:"),
                          Wrap(
                            spacing: 8,
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
                      "Productos",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];

                      return ProductCard(
                        name: item['name'] ?? '',
                        description: item['description'] ?? '',
                        image: item['image'] ?? '',
                        safe: item['safe'] ?? true,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
