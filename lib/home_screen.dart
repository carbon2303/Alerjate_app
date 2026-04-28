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

  void cambiarSeccion(String seccion) {
    setState(() {
      seccionActual = seccion;
      resultado = "";
      searchController.clear();
    });
  }

  String getTituloBuscador() {
    switch (seccionActual) {
      case "alimentos":
        return "Buscar alimento";
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
      case "alimentos":
        return "Buscar alimentos...";
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
          "Haz preguntas sobre alimentos, ingredientes y medicamentos.",
          Icons.chat,
        ),
      );
    }

    if (seccionActual != "alimentos") {
      tarjetas.add(
        featureCard(
          "Alimentos",
          "Consulta alimentos seguros según tus alergias.",
          Icons.restaurant,
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
      appBar: AppBar(
        title: const Text("Alerjiate"),
        actions: [
          menuButton("Inicio", "inicio"),
          menuButton("Alimentos", "alimentos"),
          menuButton("Fármacos", "farmacos"),
          menuButton("Chat IA", "chat"),

          // Navegación real al login
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
              padding: const EdgeInsets.all(25),
              child: const Column(
                children: [
                  Text(
                    "Encuentra productos seguros para ti",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Plataforma inteligente para identificar alimentos y medicamentos compatibles con tus alergias.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
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
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: getPlaceholder(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: accionPrincipal,
                        child: const Icon(Icons.search),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    resultado,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // TARJETAS DINÁMICAS
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
      child: Text(texto, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget featureCard(String titulo, String descripcion, IconData icono) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icono, size: 40),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(descripcion, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
