import 'package:flutter/material.dart';
import 'package:skin_match/screens/search_screen.dart';
import 'package:skin_match/screens/beautyprofile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:skin_match/screens/detail_screen.dart';
import 'package:skin_match/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  // User data
  String userskintype = "";
  String userskintypeForQuery = "";
  List<Map<String, dynamic>> matchedProducts = [];
  bool isLoadingProducts = false;

  // Daftar gambar untuk carousel
  final List<String> carouselImages = [
    'images/skintific.jpg',
    'images/ser.jpg',
    'images/set.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
    _loadUserskintype();
  }

  Future<void> _loadUserskintype() async {
    final prefs = await SharedPreferences.getInstance();
    String storedSkinType = prefs.getString('userskintype') ?? "";
    print('Loaded skin type from prefs: "$storedSkinType"');
    String normalizedSkinType = storedSkinType.trim().toLowerCase();
    if (!mounted) return;
    setState(() {
      userskintype = storedSkinType;
      userskintypeForQuery = _mapskintypeToQueryValue(normalizedSkinType);
    });
    print('Mapped skin type for query: "$userskintypeForQuery"');
    if (userskintypeForQuery.isNotEmpty) {
      _loadMatchedProducts();
    }
  }

  String _mapskintypeToQueryValue(String skintypeLabel) {
    switch (skintypeLabel.toLowerCase()) {
      case 'dry skin':
      case 'dry':
        return 'dry skin';
      case 'normal skin':
      case 'normal':
        return 'normal skin';
      case 'combination':
      case 'combination skin':
        return 'combination';
      case 'oily skin':
      case 'oily':
        return 'oily skin';
      default:
        return '';
    }
  }

  Future<void> _loadMatchedProducts() async {
    if (!mounted) return;
    setState(() {
      isLoadingProducts = true;
    });

    try {
      print('Querying products with skintype: "$userskintypeForQuery"');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('skintype', isEqualTo: userskintypeForQuery)
          .limit(3) // Batasi 3 produk untuk tampilan awal
          .get();

      List<Map<String, dynamic>> products = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        products.add(data);
      }

      print('Found ${products.length} matched products');
      if (!mounted) return;
      setState(() {
        matchedProducts = products;
        isLoadingProducts = false;
      });
    } catch (e) {
      print('Error loading matched products: $e');
      if (!mounted) return;
      setState(() {
        isLoadingProducts = false;
      });
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < carouselImages.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
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
    _timer?.cancel();
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
              // Search Bar
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

              // Carousel
              SizedBox(
                height: 200,
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

              // Dots Indicator
              const SizedBox(height: 10),
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
                          ? Colors.pink
                          : Colors.grey.withOpacity(0.5),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Product Matches Section
              if (userskintype.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Product Matches',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                        fontFamily: 'DeliciousHandrawn',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Cocok untuk kulit ${userskintype.toLowerCase()}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 15),

                // Product Matches Grid
                if (isLoadingProducts)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                      ),
                    ),
                  )
                else if (matchedProducts.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.pink[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.spa_outlined,
                          size: 48,
                          color: Colors.pink[300],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Belum ada produk yang cocok',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.pink,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Pastikan skin type sudah dipilih di profil',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: matchedProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductMatchCard(matchedProducts[index]);
                      },
                    ),
                  ),
                const SizedBox(height: 20),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.pink[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Colors.pink[300],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Lengkapi beauty profile Anda untuk melihat produk yang cocok',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.pink,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BeautyProfileScreen(),
                            ),
                          );
                          if (result != null && result is String) {
                            setState(() {
                              userskintype = result;
                              userskintypeForQuery = _mapskintypeToQueryValue(result);
                            });
                            _loadMatchedProducts();
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('userskintype', result);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Isi Beauty Profile',
                          style: TextStyle(
                            fontFamily: 'FleurDeLeah',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Trending Products Section
              const Text(
                'Trending Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                  fontFamily: 'DeliciousHandrawn',
                ),
              ),
              const SizedBox(height: 10),

              // Trending Products List
  
            ],
          ),
        ),
      ),
    );
  }

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
        ),
      ),
    );
  }


Widget _buildProductMatchCard(Map<String, dynamic> product) {
  final String name = product['name'] ?? 'Product Name';
  final String brand = product['brand'] ?? 'Brand';
  final String? imageUrl = product['imageUrl'];
  final double rating = (product['rating'] is num) ? (product['rating'] as num).toDouble() : 4.5;
  final int reviewCount = (product['reviewCount'] is int) ? product['reviewCount'] as int : 0;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DetailScreen(),
          settings: RouteSettings(arguments: product),
        ),
      );
    },
    child: Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.pink[50],
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          color: Colors.pink,
                          size: 40,
                        );
                      },
                    )
                  : const Icon(
                      Icons.spa,
                      color: Colors.pink,
                      size: 40,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  brand,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 12,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviewCount)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
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
