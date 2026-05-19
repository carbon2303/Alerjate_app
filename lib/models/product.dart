class Product {
  final String name;
  final String description;
  final String image;
  final bool safe;

  Product({
    required this.name,
    required this.description,
    required this.image,
    required this.safe,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      safe: json['safe'] ?? false,
    );
  }
}
