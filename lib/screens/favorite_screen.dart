import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skin_match/models/product.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Product> _favoriteProducts = [];
  bool _isLoading = true;

  Future<void> _loadFavoriteProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> favoriteProductIds = prefs.getStringList('favoriteProducts') ?? [];
      print('Loaded favoriteProductIds: $favoriteProductIds');

      if (favoriteProductIds.isEmpty) {
        setState(() {
          _favoriteProducts = [];
          _isLoading = false;
        });
        return;
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('id', whereIn: favoriteProductIds)
          .get();

      List<Product> products = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      setState(() {
        _favoriteProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading favorite products: $e');
      setState(() {
        _favoriteProducts = [];
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
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
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favoriteProducts.isEmpty
                ? const Center(child: Text('No favorite products found.'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
                          padding: const EdgeInsets.all(8),
                          itemCount: _favoriteProducts.length,
                          itemBuilder: (context, index) {
                            Product product = _favoriteProducts[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(detail: product)));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  margin: const EdgeInsets.all(6),
                                  elevation: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, top: 8),
                                        child: Text(
                                          product.name,
                                          style: const TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                                        child: Text(
                                          product.harga,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          },
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
