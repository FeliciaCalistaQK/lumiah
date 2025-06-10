import 'package:flutter/material.dart';
import 'package:skin_match/screens/search_screen.dart';


import 'dart:async'; // Diperlukan untuk Timer (autoplay)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  // Daftar gambar untuk carousel
  final List<String> carouselImages = [
    'images/skintific.jpg',
    'images/ser.jpg',
    'images/set.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi autoplay
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) { // Pastikan PageController sudah terpasang ke PageView
        if (_currentPage < carouselImages.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0; // Kembali ke halaman pertama setelah slide terakhir
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Pastikan timer dibatalkan saat widget di dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'SkinMatch',
          style: TextStyle(
            color: Colors.pink,
            fontFamily: 'FleurDeLeah',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.pink),
                      SizedBox(width: 10),
                      Text(
                        'Search products...',
                        style: TextStyle(color: Colors.pink),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Custom Carousel dengan PageView
              SizedBox( // Menggunakan SizedBox untuk menentukan tinggi PageView
                height: 380, // Sesuaikan dengan tinggi CarouselOptions sebelumnya
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: carouselImages.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildCarouselItem(carouselImages[index]);
                  },
                ),
              ),

              // Indikator titik (dots indicator) untuk PageView
              const SizedBox(height: 10), // Sedikit jarak dari carousel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(carouselImages.length, (index) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.pink // Warna untuk halaman aktif
                          : Colors.grey.withOpacity(0.5), // Warna untuk halaman tidak aktif
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              const Text(
                'Trending Product',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                  fontFamily: 'DeliciousHandrawn',
                ),
              ),
              const SizedBox(height: 10),

              // Trending Products List
              Column(
                children: [
                  _buildTrendingProduct(
                    userName: 'Cintia',
                    userAge: 20,
                    skinType: 'kombinasi',
                    productImage: 'images/set.jpg',
                    userImage: 'images/ser.jpg',
                    rating: 5,
                    reviewCount: 108,
                    comment: 'Suka banget sama ini produk! Cocok untuk kulit kombinasi seperti aku.',
                    usagePeriod: '3 months - 6 months',
                    purchasePoint: 'Shopee',
                  ),
                  const SizedBox(height: 10),
                  _buildTrendingProduct(
                    userName: 'Femile',
                    userAge: 25,
                    skinType: 'berminyak, berjerawat',
                    productImage: 'images/skintific.jpg',
                    userImage: 'images/user2.jpg',
                    rating: 5,
                    reviewCount: 50,
                    comment: 'Produk ini bagus! Teksturnya mudah menyerap dan efeknya terasa cepat.',
                    usagePeriod: '3 months - 6 months',
                    purchasePoint: 'Tokopedia',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Carousel Item (digunakan oleh PageView)
  Widget _buildCarouselItem(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.pink[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          // Tinggi sudah diatur oleh SizedBox di atas PageView
        ),
      ),
    );
  }

  // Widget for Trending Product (tidak berubah)
  Widget _buildTrendingProduct({
    required String userName,
    required int userAge,
    required String skinType,
    required String productImage,
    required String userImage,
    required double rating,
    required int reviewCount,
    required String comment,
    required String usagePeriod,
    required String purchasePoint,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.pink[50],
                image: DecorationImage(
                  image: AssetImage(productImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 40),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(userImage),
                        radius: 25,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$userName, $userAge tahun',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tipe kulit: $skinType',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    comment,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '$rating ($reviewCount)',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Usage: $usagePeriod',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Purchase Point: $purchasePoint',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}