import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Tambahkan package ini jika belum ada
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Untuk mendapatkan nama pengguna atau ID pengguna
import 'package:skin_match/models/review.dart';
import 'package:skin_match/models/user.dart'; // Import model Review

class ReviewPage extends StatefulWidget {
  final String productId;

  const ReviewPage({super.key, required this.productId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _currentRating = 3.0; // Nilai rating awal
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  // Fungsi untuk menyimpan review ke Firestore
  Future<void> _submitReview() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Komentar tidak boleh kosong!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Dapatkan pengguna saat ini. Anda perlu mengimplementasikan Firebase Auth
      // Jika Anda tidak menggunakan Firebase Auth, Anda bisa menggunakan nama default
      // atau meminta pengguna memasukkan nama mereka.
      firebase_auth.User? currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      String userName = currentUser?.displayName ?? currentUser?.email ?? 'Anonymous User';
      // Atau, jika Anda ingin pengguna memasukkan namanya:
      // String userName = _userNameController.text; // Anda perlu controller terpisah untuk nama

      // Buat objek Review
      final newReview = Review(
        id: '', // ID akan diisi oleh Firestore
        productId: widget.productId,
        userName: userName,
        rating: _currentRating,
        comment: _commentController.text,
        timestamp: Timestamp.now(), // Gunakan Timestamp.now()
      );

      // Simpan ke koleksi 'reviews' di Firestore
      await FirebaseFirestore.instance.collection('reviews').add(newReview.toFirestore());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review berhasil ditambahkan!')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah submit
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan review: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Berikan rating Anda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: RatingBar.builder(
                initialRating: _currentRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tulis komentar Anda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tulis review Anda di sini...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey[100],
                filled: true,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Review',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
