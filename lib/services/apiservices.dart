// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   // Ganti dengan URL dasar API Anda untuk produk kosmetik
//   // Contoh: 'https://your-api-domain.com/api' atau 'http://localhost:3000' jika lokal
//   static const String baseUrl = 'https://testdatabase-2daaf-default-rtdb.firebaseio.com/skincare.json'; // <--- Ganti dengan URL API Anda

//   // Anda bisa menambahkan endpoint spesifik jika ada.
//   // Misalnya, jika kategori produk adalah bagian dari URL:
//   // static const String productsEndpoint = '/products';

//   /// Mengambil semua produk kosmetik dari API.
//   /// Asumsi: Endpoint ini mengembalikan semua kategori dan produk di dalamnya.
//   Future<Map<String, dynamic>> getAllProducts() async {
//     final response = await http.get(Uri.parse('$baseUrl/products')); // <--- Sesuaikan endpoint jika perlu

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       // Asumsi: API mengembalikan objek JSON seperti yang Anda berikan sebelumnya
//       // { "Moisturizer": [...], "Toner": [...], ... }
//       return Map<String, dynamic>.from(data);
//     } else {
//       // Menangani error jika respons tidak 200 OK
//       throw Exception('Failed to load all products: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }

//   /// Mengambil produk berdasarkan kategori tertentu.
//   /// Asumsi: Endpoint ini bisa disaring berdasarkan kategori, atau Anda akan menyaringnya di sisi klien.
//   /// Lebih baik jika API Anda mendukung filter kategori langsung (misalnya '/products?category=Moisturizer').
//   Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
//     // Pendekatan 1: Jika API mendukung endpoint spesifik per kategori (disarankan)
//     // final response = await http.get(Uri.parse('$baseUrl/products/$category'));
//     // atau
//     // final response = await http.get(Uri.parse('$baseUrl/products?category=$category'));

//     // Pendekatan 2: Jika API hanya punya satu endpoint semua produk, dan Anda filter di aplikasi
//     // Untuk ini, Anda perlu memanggil getAllProducts() terlebih dahulu
//     final allProductsResponse = await getAllProducts();
//     if (allProductsResponse.containsKey(category)) {
//       return List<Map<String, dynamic>>.from(allProductsResponse[category]);
//     } else {
//       // Mengembalikan list kosong jika kategori tidak ditemukan
//       return [];
//     }

//     // if (response.statusCode == 200) {
//     //   final data = json.decode(response.body);
//     //   return List<Map<String, dynamic>>.from(data);
//     // } else {
//     //   throw Exception('Failed to load products for category $category');
//     // }
//   }

//   /// Mengambil produk berdasarkan pencarian (query).
//   /// Asumsi: API Anda memiliki endpoint pencarian.
//   Future<List<Map<String, dynamic>>> searchProducts(String query) async {
//     final response = await http.get(Uri.parse('$baseUrl/search?q=$query')); // <--- Sesuaikan endpoint & parameter query

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       // Asumsi: Hasil pencarian adalah array produk
//       return List<Map<String, dynamic>>.from(data['results']); // <--- Sesuaikan 'results' jika API Anda menggunakan key lain
//     } else {
//       throw Exception('Failed to search products: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }

//   // --- Anda bisa menambahkan fungsi lain di sini, misalnya untuk menambahkan/mengupdate produk ---

//   /// Contoh: Menambahkan produk baru (membutuhkan endpoint POST di API Anda)
//   Future<Map<String, dynamic>> addProduct(String category, Map<String, dynamic> productData) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/products/$category'), // <--- Sesuaikan endpoint
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(productData),
//     );

//     if (response.statusCode == 201 || response.statusCode == 200) { // 201 Created atau 200 OK
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to add product: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }

//   /// Contoh: Mengupdate produk (membutuhkan endpoint PUT/PATCH di API Anda)
//   Future<Map<String, dynamic>> updateProduct(String productId, Map<String, dynamic> productData) async {
//     final response = await http.put( // Atau http.patch
//       Uri.parse('$baseUrl/products/$productId'), // <--- Sesuaikan endpoint dan cara mengidentifikasi produk
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(productData),
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to update product: ${response.statusCode} ${response.reasonPhrase}');
//     }
//   }
// }