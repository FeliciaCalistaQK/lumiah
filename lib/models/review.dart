import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final Timestamp timestamp;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    double parsedRating = 0.0;
    if (data['rating'] is num) { // Cek apakah tipenya number
      parsedRating = (data['rating'] as num).toDouble();
    } else if (data['rating'] is String) { // Jika ternyata string, coba parse
      parsedRating = double.tryParse(data['rating']) ?? 0.0;
    }

    return Review(
      id: doc.id,
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonim',
      comment: data['comment'] ?? '',
      rating: parsedRating, // Gunakan hasil parsing
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'timestamp': timestamp,
    };
  }
}