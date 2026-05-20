import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/local_storage.dart';
import '../widgets/chat_widget.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiBase = "https://alerjate-production.up.railway.app/api";

  final TextEditingController searchController = TextEditingController();

  List products = [];
  List allergens = [];
  List<int> selectedAllergens = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadAllergens();
  }

  // ================= TOKEN =================
  Future<String?> token() async {
    return await LocalStorage.getToken();
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await LocalStorage.clearToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // ================= PRODUCTOS =================
  Future<void> loadProducts() async {
    setState(() => loading = true);

    final t = await token();
    if (t == null) return;

    final res = await http.get(
      Uri.parse("$apiBase/products"),
      headers: {
        "Authorization": "Bearer $t",
        "Accept": "application/json",
      },
    );

    final data = jsonDecode(res.body);

    setState(() {
      products = data is List ? data : (data["products"] ?? []);
      loading = false;
    });
  }

  // ================= BUSCADOR (ARREGLADO) =================
  Future<void> search(String q) async {
    final query = q.trim();

    if (query.isEmpty) {
      await loadProducts();
      return;
    }

    setState(() => loading = true);

    try {
      final t = await token();
      if (t == null) return;

      final res = await http.post(
        Uri.parse("$apiBase/search"),
        headers: {
          "Authorization": "Bearer $t",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"query": query}),
      );

      final decoded = jsonDecode(res.body);

      List result = [];

      if (decoded is List) {
        result = decoded;
      } else if (decoded["products"] != null) {
        result = decoded["products"];
      } else if (decoded["data"] != null) {
        result = decoded["data"];
      } else if (decoded["result"] != null) {
        result = decoded["result"];
      }

      setState(() {
        products = result;
        loading = false;
      });
    } catch (e) {
      debugPrint("SEARCH ERROR: $e");

      setState(() => loading = false);
    }
  }

  // ================= IMÁGENES =================
  String getImage(p) {
    const base = "https://alerjate-production.up.railway.app";

    if (p["image_url"] != null) return p["image_url"];
    if (p["image"] != null) return p["image"];
    if (p["image_path"] != null) return p["image_path"];

    if (p["barcode"] != null) {
      return "$base/assets/images/${p["barcode"]}.png";
    }

    return "$base/assets/images/default.png";
  }

  // ================= ALÉRGENOS =================
  Future<void> loadAllergens() async {
    final t = await token();
    if (t == null) return;

    final res = await http.get(
      Uri.parse("$apiBase/allergens"),
      headers: {
        "Authorization": "Bearer $t",
        "Accept": "application/json",
      },
    );

    final data = jsonDecode(res.body);

    setState(() {
      allergens = data is List ? data : [];
    });
  }

  Future<void> saveAllergens() async {
    final t = await token();
    if (t == null) return;

    await http.post(
      Uri.parse("$apiBase/user/allergens"),
      headers: {
        "Authorization": "Bearer $t",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "allergen_ids": selectedAllergens,
      }),
    );

    Navigator.pop(context);
  }

  // ================= MODAL EXPEDIENTE =================
  void openAllergenModal() {
    loadAllergens();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return AlertDialog(
              title: const Text("🛡️ Expediente clínico"),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: allergens.map((a) {
                      final checked = selectedAllergens.contains(a["id"]);

                      return CheckboxListTile(
                        value: checked,
                        title: Text(a["name"]),
                        onChanged: (v) {
                          setModal(() {
                            if (v == true) {
                              selectedAllergens.add(a["id"]);
                            } else {
                              selectedAllergens.remove(a["id"]);
                            }
                          });
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar"),
                ),
                ElevatedButton(
                  onPressed: saveAllergens,
                  child: const Text("Guardar"),
                )
              ],
            );
          },
        );
      },
    );
  }

  // ================= MENU ITEM =================
  Widget _menuItem(IconData icon, String text, VoidCallback onTap,
      {Color color = const Color(0xFF06045E)}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF06045E),
        foregroundColor: Colors.white,
        toolbarHeight: 75,
        title: const Text("Alerjate"),
      ),

      // ================= DRAWER (8 SECCIONES) =================
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              color: const Color(0xFF06045E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.health_and_safety, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "Alerjate",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Menú principal",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            _menuItem(Icons.home, "Inicio", () {
              Navigator.pop(context);
              loadProducts();
            }),
            _menuItem(Icons.search, "Buscar", () {
              Navigator.pop(context);
            }),
            _menuItem(Icons.health_and_safety, "Expediente", () {
              Navigator.pop(context);
              openAllergenModal();
            }),
            _menuItem(Icons.favorite, "Favoritos", () {
              Navigator.pop(context);
            }),
            _menuItem(Icons.history, "Historial", () {
              Navigator.pop(context);
            }),
            _menuItem(Icons.notifications, "Notificaciones", () {
              Navigator.pop(context);
            }),
            _menuItem(Icons.settings, "Configuración", () {
              Navigator.pop(context);
            }),
            const Spacer(),
            _menuItem(Icons.logout, "Cerrar sesión", logout, color: Colors.red),
          ],
        ),
      ),

      // ================= BODY =================
      body: Stack(
        children: [
          Column(
            children: [
              // SEARCH
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: search,
                  decoration: InputDecoration(
                    hintText: "Buscar productos...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // PRODUCTS
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : products.isEmpty
                        ? const Center(child: Text("Sin productos"))
                        : GridView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                            ),
                            itemBuilder: (c, i) {
                              final p = products[i];

                              return Container(
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        getImage(p),
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.image),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        p["name"] ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
          const ChatWidget(),
        ],
      ),
    );
  }
}
