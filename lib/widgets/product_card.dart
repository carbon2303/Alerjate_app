import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String image;
  final bool safe;

  const ProductCard({
    super.key,
    required this.name,
    required this.description,
    required this.image,
    required this.safe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),

      child: Row(
        children: [
          // ======================
          // IMAGEN
          // ======================
          ClipRRect(
            borderRadius: BorderRadius.circular(12),

            child: Image.asset(image, width: 90, height: 90, fit: BoxFit.cover),
          ),

          const SizedBox(width: 16),

          // ======================
          // INFO
          // ======================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: safe ? Colors.green : Colors.red,

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Text(
                    safe ? "Seguro" : "Peligro",

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
