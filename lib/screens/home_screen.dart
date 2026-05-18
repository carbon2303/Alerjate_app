import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService productService = ProductService();

  List<dynamic> products = [];
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      loading = true;
      error = false;
    });

    final data = await productService.getProducts(widget.token);

    if (!mounted) return;

    setState(() {
      products = data;
      loading = false;
      error = data.isEmpty;
    });
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5CC5DF),

      appBar: AppBar(
        title: const Text("Productos"),
        backgroundColor: const Color(0xFF03055D),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadProducts,

        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error
            ? ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("Error o no hay productos")),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];

                  return ProductCard(
                    name: p['name'] ?? '',
                    description: p['description'] ?? '',
                    image: p['image'] ?? 'https://via.placeholder.com/100',
                    safe: p['safe'] ?? false,
                  );
                },
              ),
      ),
    );
  }
}
