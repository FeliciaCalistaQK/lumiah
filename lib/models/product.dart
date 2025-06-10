class Product {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviews;
  final String description;
  final String category;
  final String harga;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.category,
    required this.harga,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Penanganan yang lebih robust untuk rating dan reviews
    double parsedRating = 0.0;
    if (json['rating'] is num) { // Cek apakah tipenya number
      parsedRating = (json['rating'] as num).toDouble();
    } else if (json['rating'] is String) { // Jika ternyata string, coba parse
      parsedRating = double.tryParse(json['rating']) ?? 0.0;
    }

    int parsedReviews = 0;
    if (json['reviews'] is num) { // Cek apakah tipenya number
      parsedReviews = (json['reviews'] as num).toInt();
    } else if (json['reviews'] is String) { // Jika ternyata string, coba parse
      parsedReviews = int.tryParse(json['reviews']) ?? 0;
    }

    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      rating: parsedRating, // Gunakan hasil parsing
      reviews: parsedReviews, // Gunakan hasil parsing
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      harga: json['harga'] ?? 'Harga tidak tersedia',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'category': category,
      'harga': harga,
    };
  }
}