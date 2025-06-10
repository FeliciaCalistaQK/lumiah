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

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadFavoriteProduct();
//   }

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
