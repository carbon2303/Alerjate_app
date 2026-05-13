import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool ocultarPassword = true;

  void iniciarSesion() {
    String correo = correoController.text.trim();
    String password = passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget navButton(String texto) {
    return TextButton(
      onPressed: () {
        if (texto == "Inicio") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },

      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5CC5DF),

      body: SafeArea(
        child: Column(
          children: [
            // NAVBAR
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              color: const Color(0xFF03055D),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  // LOGO + NOMBRE
                  Row(
                    children: [
                      Image.asset('assets/logo.png', width: 55),

                      const SizedBox(width: 10),

                      const Text(
                        "Alerjiate",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // MENU
                  Wrap(
                    spacing: 10,
                    children: [
                      navButton("Inicio"),
                      navButton("Alimentos"),
                      navButton("Fármacos"),
                      navButton("Chat IA"),
                    ],
                  ),
                ],
              ),
            ),

            // CONTENIDO
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,

                  child: Center(
                    child: Container(
                      width: 400,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(35),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(20),

                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 15),
                        ],
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // LOGO
                          Image.asset('assets/logo.png', width: 90),

                          const SizedBox(height: 20),

                          // TITULO
                          const Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // SUBTITULO
                          const Text(
                            "Accede para consultar productos seguros para ti",
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 25),

                          // CORREO
                          TextField(
                            controller: correoController,

                            decoration: InputDecoration(
                              hintText: "Correo electrónico",

                              filled: true,
                              fillColor: Colors.white,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // PASSWORD
                          TextField(
                            controller: passwordController,

                            obscureText: ocultarPassword,

                            decoration: InputDecoration(
                              hintText: "Contraseña",

                              filled: true,
                              fillColor: Colors.white,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),

                              suffixIcon: IconButton(
                                icon: Icon(
                                  ocultarPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),

                                onPressed: () {
                                  setState(() {
                                    ocultarPassword = !ocultarPassword;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // BOTON
                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF03055D),

                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              onPressed: iniciarSesion,

                              child: const Text(
                                "Entrar",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // REGISTRO
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              const Text("¿No tienes cuenta?"),

                              TextButton(
                                onPressed: () {},

                                child: const Text("Regístrate"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
