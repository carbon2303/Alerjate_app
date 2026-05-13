import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String seccionActual = "inicio";
  String resultado = "";

  final TextEditingController searchController = TextEditingController();

  final Color primaryColor = const Color(0xFF5CC5DF);
  final Color secondaryColor = const Color(0xFFF5F6FA);
  final Color textColor = const Color(0xFF2F3640);

  void cambiarSeccion(String seccion) {
    setState(() {
      seccionActual = seccion;
      resultado = "";
      searchController.clear();
    });
  }

  String getTituloBuscador() {
    switch (seccionActual) {
      case "farmacos":
        return "Buscar fármaco";
      case "chat":
        return "Pregunta al Chat IA";
      default:
        return "Buscar alimento o medicamento";
    }
  }

  String getPlaceholder() {
    switch (seccionActual) {
      case "farmacos":
        return "Buscar medicamentos...";
      case "chat":
        return "Escribe tu pregunta...";
      default:
        return "Buscar alimentos o medicamentos...";
    }
  }

  void accionPrincipal() {
    setState(() {
      if (searchController.text.trim().isEmpty) {
        resultado = "Escribe algo para buscar";
        return;
      }

      if (seccionActual == "chat") {
        resultado = "IA: Respuesta simulada para: ${searchController.text}";
      } else {
        resultado = "Resultado de búsqueda para: ${searchController.text}";
      }
    });
  }

  List<Widget> obtenerTarjetas() {
    List<Widget> tarjetas = [];

    if (seccionActual != "farmacos") {
      tarjetas.add(
        featureCard(
          "Buscador de fármacos",
          "Verifica componentes y posibles riesgos alérgicos.",
          Icons.medical_services,
        ),
      );
    }

    if (seccionActual != "chat") {
      tarjetas.add(
        featureCard(
          "Chat IA",
          "Haz preguntas sobre ingredientes y medicamentos.",
          Icons.chat_bubble_outline,
        ),
      );
    }

    return tarjetas;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "Alerjiate",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          menuButton("Inicio", "inicio"),
          menuButton("Fármacos", "farmacos"),
          menuButton("Chat IA", "chat"),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("Login", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    "Encuentra productos seguros para ti",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Plataforma inteligente para identificar alimentos y medicamentos compatibles con tus alergias.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // BUSCADOR
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    getTituloBuscador(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: getPlaceholder(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: accionPrincipal,
                        child: const Icon(Icons.search),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    resultado,
                    style: TextStyle(fontSize: 16, color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // TARJETAS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: obtenerTarjetas(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuButton(String texto, String seccion) {
    return TextButton(
      onPressed: () => cambiarSeccion(seccion),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget featureCard(String titulo, String descripcion, IconData icono) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(blurRadius: 8, spreadRadius: 1, color: Colors.black12),
        ],
      ),
      child: Column(
        children: [
          Icon(icono, size: 40, color: primaryColor),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }
}
