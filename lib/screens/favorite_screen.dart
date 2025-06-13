// import 'package:flutter/material.dart';
// import 'package:skin_match/data/product_data.dart';
// import 'package:skin_match/models/product.dart';
// import 'package:skin_match/screens/detail_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FavoriteScreen extends StatefulWidget {
//   const FavoriteScreen({super.key});

//   @override
//   State<FavoriteScreen> createState() => _FavoriteScreenState();
// }

<<<<<<< Updated upstream
// class _FavoriteScreenState extends State<FavoriteScreen> {
//   List<Product> _favoriteProducts = [];

//   Future<void> _loadFavoriteProduct() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> favoriteProductNames = prefs.getStringList('favoriteProducts') ?? [];

//     setState(() {
//       _favoriteProducts = productsByCategory.entries
//           .expand((entry) => entry.value)  // Meratakan semua produk
//           .where((product) => favoriteProductNames.contains(product.name))  // Filter berdasarkan nama
//           .toList();  // Mengubah hasil menjadi List<Product>
//     });

//   }
=======
class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Product> _favoriteProducts = [];
  bool _isLoading = true;
  List<String> _favoriteProductIds = [];

  Future<void> _loadFavoriteProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoriteProductIds = prefs.getStringList('favoriteProducts') ?? [];

    if (_favoriteProductIds.isEmpty) {
      setState(() {
        _favoriteProducts = [];
        _isLoading = false;
      });
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('id', whereIn: _favoriteProductIds)
          .get();
>>>>>>> Stashed changes

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadFavoriteProduct();
//   }

<<<<<<< Updated upstream
//   @override
//    Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'SkinMatch',
//           style: TextStyle(
//             color: Colors.pink,
//             fontFamily: 'FleurDeLeah',
//             fontSize: 24,
//           ),
//         ),
//         centerTitle: true,
       
//       ),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Column(
//           children: [
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
//               padding: const EdgeInsets.all(8),
//               itemCount: _favoriteProducts.length,
//               itemBuilder: (context, index) {
//                 Product product = _favoriteProducts[index];
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 DetailScreen(detail:product)));
//                   },
//                   child: Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16)),
//                       margin: const EdgeInsets.all(6),
//                       elevation: 1,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           // Gambar 
//                           Expanded(
//                               child: ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.network(
//                               product.image,
//                               fit: BoxFit.cover,
//                             ),
//                           )),
//                           // Nama 
//                           Padding(
//                             padding: const EdgeInsets.only(left: 16, top: 8),
//                             child: Text(
//                               product.name,
//                               style: const TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         //harga
//                           Padding(
//                             padding: const EdgeInsets.only(left: 16, bottom: 8),
//                             child: Text(
//                               product.harga,
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       )),
//                 );
//               },
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }
=======
      setState(() {
        _favoriteProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors here if needed
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

  void _toggleFavorite(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteProductIds.contains(product.id)) {
        _favoriteProductIds.remove(product.id);
        _favoriteProducts.removeWhere((p) => p.id == product.id);
      } else {
        _favoriteProductIds.add(product.id);
        _favoriteProducts.add(product);
      }
    });
    await prefs.setStringList('favoriteProducts', _favoriteProductIds);
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
                            bool isFavorite = _favoriteProductIds.contains(product.id);
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const DetailScreen(),
                                        settings: RouteSettings(arguments: product),
                                      ));
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
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              product.image,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: IconButton(
                                                icon: Icon(
                                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                                  color: isFavorite ? Colors.red : Colors.grey,
                                                ),
                                                onPressed: () {
                                                  _toggleFavorite(product);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
>>>>>>> Stashed changes
