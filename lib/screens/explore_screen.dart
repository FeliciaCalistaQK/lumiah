import 'package:flutter/material.dart';
import 'package:skin_match/screens/detail_screen.dart';
import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore


class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryScreen(),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SkinMatch',
          style: TextStyle(
            color: Colors.pink,
            fontFamily: 'FleurDeLeah',
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'Category',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildCategoryItem(context, Icons.water_drop, 'Moisturizer'),
                  _buildCategoryItem(context, Icons.cleaning_services, 'Toner'),
                  _buildCategoryItem(context, Icons.science, 'Serum'),
                  _buildCategoryItem(context, Icons.wb_sunny, 'Sunscreen'),
                  _buildCategoryItem(context, Icons.face, 'Face Mask'),
                  _buildCategoryItem(context, Icons.face_3, 'Lips Care'),
                  _buildCategoryItem(context, Icons.soap, 'Cleanser'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun item kategori dengan navigasi
  Widget _buildCategoryItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryDetailScreen(title: label)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.pink, size: 40),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen dengan desain grid untuk menampilkan daftar produk
class CategoryDetailScreen extends StatelessWidget {
  final String title;

  const CategoryDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.pink,
            fontFamily: 'FleurDeLeah',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products') // Nama koleksi di Firestore
            .where('category', isEqualTo: title) // Filter berdasarkan kategori
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<Product> products = snapshot.data!.docs.map((doc) {
            return Product.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

          if (products.isEmpty) {
            return Center(child: Text('Tidak ada produk untuk kategori ini.'));
          }

          // Fetch review counts for all products
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('reviews')
                .where('productId', whereIn: products.map((p) => p.id).toList())
                .get(),
            builder: (context, reviewSnapshot) {
              if (reviewSnapshot.hasError) {
                return Center(child: Text('Terjadi kesalahan: ${reviewSnapshot.error}'));
              }

              if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Count reviews per productId and calculate average rating
              Map<String, int> reviewCounts = {};
              Map<String, double> ratingSums = {};
              for (var doc in reviewSnapshot.data!.docs) {
                String productId = doc['productId'];
                double rating = (doc['rating'] as num).toDouble();
                reviewCounts[productId] = (reviewCounts[productId] ?? 0) + 1;
                ratingSums[productId] = (ratingSums[productId] ?? 0) + rating;
              }
              print('Fetched ${reviewSnapshot.data!.docs.length} reviews for products in category $title');

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final reviewCount = reviewCounts[product.id] ?? 0;
                    final averageRating = reviewCount > 0 ? (ratingSums[product.id]! / reviewCount) : 0.0;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(detail: product),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.pink.shade100, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              child: Image.network(
                                product.image,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              product.name,
                              style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${averageRating.toStringAsFixed(1)} ★ $reviewCount Reviews',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Hapus kelas-kelas StatelessWidget yang hanya mengarahkan ke CategoryDetailScreen
// Contoh: MoisturizerScreen, TonerScreen, dll.
// Karena kita sudah mengirim 'title' langsung dari _buildCategoryItem