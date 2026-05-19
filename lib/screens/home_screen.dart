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
  // BUSCAR PRODUCTO
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
      // DRAWER
      // ======================
      drawer: const AppDrawer(),

      backgroundColor: const Color(0xFFF5F7FA),

      // ======================
      // APPBAR
      // ======================
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CC5DF),

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "ALERJATE",

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                  // HERO SECTION
                  // ======================
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 40,
                    ),

                    decoration: const BoxDecoration(
                      color: Color(0xFF5CC5DF),

                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),

                        bottomRight: Radius.circular(40),
                      ),
                    ),

                    child: Column(
                      children: [
                        Image.asset('assets/images/logo.png', height: 120),

                        const SizedBox(height: 20),

                        const Text(
                          "Encuentra productos seguros para ti",

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "Sistema inteligente para identificar alimentos y medicamentos compatibles con tus alergias.",

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 16,

                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ======================
                  // SEARCH BAR
                  // ======================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,

                            decoration: InputDecoration(
                              hintText: "Buscar producto...",

                              prefixIcon: const Icon(Icons.search),

                              filled: true,

                              fillColor: Colors.white,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),

                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        SizedBox(
                          height: 55,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF06045E),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),

                            onPressed: searchProduct,

                            child: const Text(
                              "Buscar",

                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ======================
                  // SEARCH LOADING
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
                      margin: const EdgeInsets.all(16),

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(22),

                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 8),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            searchResult!["product"]["name"],

                            style: const TextStyle(
                              fontSize: 24,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Categoría: ${searchResult!["product"]["category"]}",

                            style: TextStyle(color: Colors.grey[700]),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Alérgenos detectados",

                            style: TextStyle(
                              fontWeight: FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,

                            runSpacing: 8,

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
                    padding: EdgeInsets.symmetric(horizontal: 16),

                    child: Text(
                      "Productos destacados",

                      style: TextStyle(
                        fontSize: 22,

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

                        image: ImageService.getImage(item['name'] ?? ''),

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
