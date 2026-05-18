import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alerjate',
      theme: ThemeData(fontFamily: 'Arial'),
      home: const LoginScreen(),
    );
  }
}
