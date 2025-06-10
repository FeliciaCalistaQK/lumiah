import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String productId;
  final String userName; // Tambahkan ini jika Anda ingin menampilkan nama pengguna
  final double rating;
  final String comment;
  final Timestamp timestamp; // Menggunakan Timestamp dari cloud_firestore

  Review({
    required this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  // Constructor untuk membuat objek Review dari Firestore DocumentSnapshot
  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      productId: data['productId'] as String,
      userName: data['userName'] as String? ?? 'Anonymous', // Default jika tidak ada
      rating: (data['rating'] as num).toDouble(), // Pastikan double
      comment: data['comment'] as String,
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  // Method untuk mengonversi objek Review ke Map untuk Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}