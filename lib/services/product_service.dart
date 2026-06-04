import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://dummyjson.com/products';
  static const String _cacheKey = 'cached_products';
  static const String _cacheDateKey = 'cache_date';

  Future<List<Product>> getProducts({int limit = 30, int skip = 0}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl?limit=$limit&skip=$skip'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products =
            (data['products'] as List).map((p) => Product.fromJson(p)).toList();

        await _cacheProducts(products);
        return products;
      } else {
        return await _getCachedProducts();
      }
    } catch (_) {
      return await _getCachedProducts();
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/search?q=$query'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['products'] as List)
            .map((p) => Product.fromJson(p))
            .toList();
      }
    } catch (_) {}

    final cached = await _getCachedProducts();
    return cached
        .where((p) =>
            p.title.toLowerCase().contains(query.toLowerCase()) ||
            p.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> _cacheProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList(_cacheKey, jsonList);
    await prefs.setString(_cacheDateKey, DateTime.now().toIso8601String());
  }

  Future<List<Product>> _getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_cacheKey) ?? [];
    return jsonList.map((s) => Product.fromJson(json.decode(s))).toList();
  }

  Future<bool> hasCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cacheKey);
  }

  Future<String?> getCacheDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cacheDateKey);
  }
}
