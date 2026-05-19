import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/local_storage.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,

        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF06045E)),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                const Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 50,
                ),

                const SizedBox(height: 10),

                const Text(
                  "ALERJATE",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Sistema Inteligente",

                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // ======================
          // INICIO
          // ======================
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Inicio"),

            onTap: () {
              Navigator.pop(context);
            },
          ),

          // ======================
          // ALIMENTOS
          // ======================
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text("Alimentos"),

            onTap: () {},
          ),

          // ======================
          // FÁRMACOS
          // ======================
          ListTile(
            leading: const Icon(Icons.medication),
            title: const Text("Fármacos"),

            onTap: () {},
          ),

          // ======================
          // PERFIL MÉDICO
          // ======================
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text("Perfil Médico"),

            onTap: () {},
          ),

          // ======================
          // CHAT IA
          // ======================
          ListTile(
            leading: const Icon(Icons.smart_toy),
            title: const Text("Chat IA"),

            onTap: () {},
          ),

          // ======================
          // FAVORITOS
          // ======================
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("Favoritos"),

            onTap: () {},
          ),

          // ======================
          // CONFIGURACIÓN
          // ======================
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Configuración"),

            onTap: () {},
          ),

          const Divider(),

          // ======================
          // LOGOUT
          // ======================
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),

            title: const Text(
              "Cerrar sesión",

              style: TextStyle(color: Colors.red),
            ),

            onTap: () async {
              await LocalStorage.logout();

              Navigator.pushReplacement(
                context,

                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
