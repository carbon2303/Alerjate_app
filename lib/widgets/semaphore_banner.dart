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

      margin: const EdgeInsets.symmetric(horizontal: 20),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, color: Colors.white, size: 35),

          const SizedBox(width: 10),

          Text(
            text,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
