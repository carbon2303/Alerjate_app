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

  final TextEditingController searchController = TextEditingController();

  Map<String, dynamic>? searchResult;

  bool searching = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // =========================
  // CARGAR PRODUCTOS
  // =========================

  Future<void> loadProducts() async {
    final token = await LocalStorage.getToken();

    if (token == null) {
      return;
    }

    final data = await _service.getProducts(token);

    setState(() {
      products = List<Map<String, dynamic>>.from(data);

      loading = false;
    });
  }

  // =========================
  // BÚSQUEDA
  // =========================

  Future<void> searchProduct() async {
    if (searchController.text.isEmpty) {
      return;
    }

    setState(() {
      searching = true;
    });

    final data = await _service.searchProduct(searchController.text);

    if (mounted) {
      setState(() {
        searchResult = data;

        searching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======================
      // MENU LATERAL
      // ======================
      drawer: const AppDrawer(),

      backgroundColor: Colors.grey[100],

      // ======================
      // APPBAR
      // ======================
      appBar: AppBar(
        title: const Text("ALERJATE"),
        centerTitle: true,
        elevation: 0,
      ),

      // ======================
      // BODY
      // ======================
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ======================
                  // SEARCH BAR
                  // ======================
                  Padding(
                    padding: const EdgeInsets.all(12),

                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,

                            decoration: InputDecoration(
                              hintText: "Buscar productos...",

                              prefixIcon: const Icon(Icons.search),

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

                  // ======================
                  // LOADING SEARCH
                  // ======================
                  if (searching)
                    const Padding(
                      padding: EdgeInsets.all(20),

                      child: Center(child: CircularProgressIndicator()),
                    ),

                  // ======================
                  // SEMÁFORO
                  // ======================
                  if (searchResult != null && searchResult!["status"] != null)
                    SemaphoreBanner(status: searchResult!["status"]),

                  const SizedBox(height: 20),

                  // ======================
                  // RESULTADO BÚSQUEDA
                  // ======================
                  if (searchResult != null && searchResult!["product"] != null)
                    Container(
                      margin: const EdgeInsets.all(12),

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(16),

                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // PRODUCTO
                          Text(
                            searchResult!["product"]["name"],

                            style: const TextStyle(
                              fontSize: 22,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // CATEGORÍA
                          Text(
                            "Categoría: ${searchResult!["product"]["category"]}",
                          ),

                          const SizedBox(height: 15),

                          // ALÉRGENOS
                          const Text(
                            "Alérgenos",

                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,

                            children:
                                (searchResult!["product"]["allergens"] as List)
                                    .map((a) {
                                      return Chip(
                                        label: Text(a["name"]),

                                        backgroundColor: Colors.red[100],
                                      );
                                    })
                                    .toList(),
                          ),
                        ],
                      ),
                    ),

                  // ======================
                  // TITULO
                  // ======================
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),

                    child: Text(
                      "Productos destacados",

                      style: TextStyle(
                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ======================
                  // PRODUCTOS
                  // ======================
                  ListView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: products.length,

                    itemBuilder: (context, index) {
                      final item = products[index];

                      return ProductCard(
                        name: item['name'] ?? 'Sin nombre',

                        description: item['description'] ?? '',

                        image:
                            item['image'] ?? 'https://via.placeholder.com/150',

                        safe: item['safe'] ?? true,
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
