class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.sku,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
    required this.colorway,
    required this.rating,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      brand: json['brand'] as String,
      sku: json['sku'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      description: json['description'] as String,
      colorway: json['colorway'] as String,
      rating: (json['rating'] as num).toDouble(),
      sizes: List<String>.from(json['sizes'] as List),
    );
  }

  final int id;
  final String name;
  final String brand;
  final String sku;
  final String category;
  final double price;
  final String image;
  final String description;
  final String colorway;
  final double rating;
  final List<String> sizes;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'sku': sku,
      'category': category,
      'price': price,
      'image': image,
      'description': description,
      'colorway': colorway,
      'rating': rating,
      'sizes': sizes,
    };
  }

  @override
  String toString() => 'Product(${toJson()})';
}
