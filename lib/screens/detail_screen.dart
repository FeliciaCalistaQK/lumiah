import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_match/models/product.dart';
import 'package:skin_match/screens/rating_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:skin_match/models/review.dart'; // Import model Review

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  Product? detail;

  @override
  void initState() {
    super.initState();
    final args = WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs != null && routeArgs is Product) {
        setState(() {
          detail = routeArgs;
        });
        _loadFavoriteStatus();
      }
    });
  }

  Future<void> _loadFavoriteStatus() async {
    if (detail == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteProducts = prefs.getStringList('favoriteProducts') ?? [];
    setState(() {
      _isFavorite = favoriteProducts.contains(detail!.id);
    });
  }

  Future<void> _toggleFavorite() async {
    if (detail == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteProducts = prefs.getStringList('favoriteProducts') ?? [];
    setState(() {
      if (_isFavorite) {
        favoriteProducts.remove(detail!.id);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${detail!.name} removed from favorites')));
      } else {
        favoriteProducts.add(detail!.id);
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${detail!.name} added to favorites')));
      }
    });
    await prefs.setStringList('favoriteProducts', favoriteProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Product',
          style: TextStyle(
            color: Colors.pink,
            fontFamily: 'FleurDeLeah',
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: detail == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          detail!.image,
                          width: 100,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
<<<<<<< Updated upstream
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Harga dan Rating Produk (menggunakan data dari widget.detail)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('reviews')
                      .where('productId', isEqualTo: widget.detail.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error loading rating');
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.detail.harga, // Menampilkan harga dari model Product
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '0.0', // No reviews yet
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    double totalRating = 0;
                    final reviews = snapshot.data!.docs;
                    for (var doc in reviews) {
                      totalRating += (doc['rating'] as num).toDouble();
                    }
                    final averageRating = totalRating / reviews.length;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.detail.harga, // Menampilkan harga dari model Product
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              averageRating.toStringAsFixed(1), // Dynamic average rating
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Deskripsi Produk (menggunakan data dari widget.detail)
                Text(
                  widget.detail.description, // Menampilkan deskripsi dari model Product
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // Tombol Add Review
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewPage(productId: widget.detail.id), // Teruskan productId ke ReviewPage
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Review',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),

                // Bagian Reviews
                // Menggunakan StreamBuilder untuk menampilkan review dari Firestore
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('reviews') // Koleksi 'reviews'
                      .where('productId', isEqualTo: widget.detail.id) // Filter berdasarkan ID produk
                      .orderBy('timestamp', descending: true) // Urutkan review terbaru di atas
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading reviews: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Belum ada review untuk produk ini.'));
                    }

                    // Menghitung rata-rata rating dan jumlah review
                    double totalRating = 0;
                    final List<Review> reviews = snapshot.data!.docs.map((doc) {
                      final review = Review.fromFirestore(doc);
                      totalRating += review.rating;
                      return review;
                    }).toList();

                    final int numberOfReviews = reviews.length;
                    final double averageRating = numberOfReviews > 0 ? totalRating / numberOfReviews : 0.0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reviews (${numberOfReviews})', // Tampilkan jumlah review
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Anda bisa menambahkan tampilan rata-rata rating di sini jika mau
                        // Contoh: Text('Rata-rata Rating: ${averageRating.toStringAsFixed(1)} ★'),

                        ListView.builder(
                          shrinkWrap: true, // Penting agar ListView di dalam SingleChildScrollView
                          physics: NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.userName,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.amber, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              '${review.rating.toStringAsFixed(1)}',
                                              style: TextStyle(fontSize: 14, color: Colors.black54),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              '${review.timestamp.toDate().day}/${review.timestamp.toDate().month}/${review.timestamp.toDate().year}',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          review.comment,
                                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                                        ),
                                      ],
=======
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detail!.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (detail!.skintype.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Skin Type: ${detail!.skintype}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
>>>>>>> Stashed changes
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _toggleFavorite,
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('reviews')
                            .where('productId', isEqualTo: detail!.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Error loading rating');
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  detail!.harga,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Icon(Icons.star, color: Colors.amber, size: 20),
                                    SizedBox(width: 4),
                                    Text(
                                      '0.0',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          double totalRating = 0;
                          final reviews = snapshot.data!.docs;
                          for (var doc in reviews) {
                            totalRating += (doc['rating'] as num).toDouble();
                          }
                          final averageRating = totalRating / reviews.length;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                detail!.harga,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    averageRating.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        detail!.description,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(productId: detail!.id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add Review',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('reviews')
                            .where('productId', isEqualTo: detail!.id)
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error loading reviews: \${snapshot.error}'));
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('Belum ada review untuk produk ini.'));
                          }
                          double totalRating = 0;
                          final List<Review> reviews = snapshot.data!.docs.map((doc) {
                            final review = Review.fromFirestore(doc);
                            totalRating += review.rating;
                            return review;
                          }).toList();
                          final int numberOfReviews = reviews.length;
                          final double averageRating = numberOfReviews > 0 ? totalRating / numberOfReviews : 0.0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reviews (\$numberOfReviews)',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                review.userName,
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '\${review.rating.toStringAsFixed(1)}',
                                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '\${review.timestamp.toDate().day}/\${review.timestamp.toDate().month}/\${review.timestamp.toDate().year}',
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                review.comment,
                                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
