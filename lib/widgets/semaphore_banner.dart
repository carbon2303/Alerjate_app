import 'package:flutter/material.dart';

class SemaphoreBanner extends StatelessWidget {
  final String status;

  const SemaphoreBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case "danger":
        color = Colors.red;
        text = "PELIGRO";
        icon = Icons.warning;
        break;

      case "warning":
        color = Colors.orange;
        text = "PRECAUCIÓN";
        icon = Icons.error_outline;
        break;

      default:
        color = Colors.green;
        text = "SEGURO";
        icon = Icons.check_circle;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
