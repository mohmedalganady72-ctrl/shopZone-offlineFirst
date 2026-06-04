import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class FavoritesService {
  static const String _favKey = 'favorites';

  Future<List<Product>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favKey) ?? [];
    return jsonList.map((s) => Product.fromJson(json.decode(s))).toList();
  }

  Future<void> addFavorite(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_favKey) ?? [];
    // Avoid duplicates
    if (!current.any((s) => json.decode(s)['id'] == product.id)) {
      current.add(json.encode(product.toJson()));
      await prefs.setStringList(_favKey, current);
    }
  }

  Future<void> removeFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_favKey) ?? [];
    current.removeWhere((s) => json.decode(s)['id'] == productId);
    await prefs.setStringList(_favKey, current);
  }

  Future<bool> isFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_favKey) ?? [];
    return current.any((s) => json.decode(s)['id'] == productId);
  }
}
