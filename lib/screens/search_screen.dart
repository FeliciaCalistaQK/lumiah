// import 'package:flutter/material.dart';
// import '../models/product.dart';
// import '../data/product_data.dart';
// import 'detail_screen.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   // Controller for TextField
//   final TextEditingController _searchController = TextEditingController();
  
//   // List to store search history
//   List<String> searchHistory = [];
  
//   // List to store search results
//   List<Product> searchResults = [];
  
//   // List of all products
//   List<Product> allProducts = [];
  
//   @override
//   void initState() {
//     super.initState();
//     // Combine all products from different categories into one list
//     productsByCategory.forEach((category, products) {
//       allProducts.addAll(products);
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   // Function to add search to history
//   void _addToSearchHistory(String query) {
//     if (query.isNotEmpty && !searchHistory.contains(query)) {
//       setState(() {
//         searchHistory.insert(0, query); // Add to beginning of list
//         if (searchHistory.length > 10) { // Limit history to 10 items
//           searchHistory.removeLast();
//         }
//       });
//     }
//   }

//   // Function to search products
//   void _searchProducts(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         searchResults.clear();
//       });
//       return;
//     }

//     setState(() {
//       searchResults = allProducts
//           .where((product) =>
//               product.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   // Function to handle history item tap
//   void _onHistoryTap(String query) {
//     _searchController.text = query;
//     _searchProducts(query);
//   }

//   @override
//   Widget build(BuildContext context) {
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
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.pink),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search TextField
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search products...',
//                 prefixIcon: const Icon(Icons.search, color: Colors.pink),
//                 filled: true,
//                 fillColor: Colors.pink[50],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide.none,
//                 ),
//                 suffixIcon: _searchController.text.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, color: Colors.pink),
//                         onPressed: () {
//                           _searchController.clear();
//                           _searchProducts('');
//                         },
//                       )
//                     : null,
//               ),
//               onChanged: _searchProducts,
//               onSubmitted: (query) {
//                 _addToSearchHistory(query);
//               },
//             ),
//             const SizedBox(height: 20),

//             // Search Results or Search History
//             Expanded(
//               child: _searchController.text.isEmpty
//                   ? _buildSearchHistory()
//                   : _buildSearchResults(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget to build search history
//   Widget _buildSearchHistory() {
//     if (searchHistory.isEmpty) {
//       return const Center(
//         child: Text(
//           'No search history yet',
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Search History',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.pink,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Expanded(
//           child: ListView.builder(
//             itemCount: searchHistory.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: const Icon(Icons.history, color: Colors.pink),
//                 title: Text(searchHistory[index]),
//                 onTap: () => _onHistoryTap(searchHistory[index]),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.grey),
//                   onPressed: () {
//                     setState(() {
//                       searchHistory.removeAt(index);
//                     });
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget to build search results
//   Widget _buildSearchResults() {
//     if (searchResults.isEmpty) {
//       return const Center(
//         child: Text(
//           'No products found',
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }

<<<<<<< Updated upstream
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16.0,
//         mainAxisSpacing: 16.0,
//         childAspectRatio: 0.75,
//       ),
//       itemCount: searchResults.length,
//       itemBuilder: (context, index) {
//         final product = searchResults[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailScreen(detail: product),
//               ),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.pink.shade100, width: 2),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   child: Image.network(
//                     product.image,
//                     width: 200,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   product.name,
//                   style: const TextStyle(
//                     color: Colors.pink,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${product.rating} ★ ${product.reviews} Reviews',
//                   style: const TextStyle(
//                     color: Colors.black54,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
=======
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: searchHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.pink),
                title: Text(searchHistory[index]),
                onTap: () => _onHistoryTap(searchHistory[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      searchHistory.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      itemCount: searchResults.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = searchResults[index];
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
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.rating} ★ ${product.reviews} Reviews',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
>>>>>>> Stashed changes
