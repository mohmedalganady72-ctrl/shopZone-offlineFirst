import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/favorites_service.dart';

enum LoadingState { idle, loading, loaded, error, offline }

class ProductsProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final FavoritesService _favoritesService = FavoritesService();

  List<Product> _products = [];
  List<Product> _favorites = [];
  List<Product> _searchResults = [];
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';
  bool _isOffline = false;
  String? _cacheDate;
  bool _isSearching = false;

  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
  List<Product> get searchResults => _searchResults;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  String? get cacheDate => _cacheDate;
  bool get isSearching => _isSearching;

  Future<void> loadProducts() async {
    _state = LoadingState.loading;
    notifyListeners();

    final hasCached = await _productService.hasCachedData();

    try {
      _products = await _productService.getProducts(limit: 30);
      _cacheDate = await _productService.getCacheDate();

      if (_products.isEmpty) {
        _state = LoadingState.error;
        _errorMessage = 'No products available.';
      } else {
        // Determine if we're in offline mode (using cached data)
        _isOffline = hasCached && _products.isNotEmpty && !await _checkConnectivity();
        _state = LoadingState.loaded;
      }
    } catch (e) {
      _state = LoadingState.error;
      _errorMessage = e.toString();
    }

    await loadFavorites();
    notifyListeners();
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await _productService.getProducts(limit: 1);
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadFavorites() async {
    _favorites = await _favoritesService.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    final isFav = await _favoritesService.isFavorite(product.id);
    if (isFav) {
      await _favoritesService.removeFavorite(product.id);
    } else {
      await _favoritesService.addFavorite(product);
    }
    await loadFavorites();
  }

  bool isFavorite(int productId) {
    return _favorites.any((p) => p.id == productId);
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isSearching = true;
    _searchResults = await _productService.searchProducts(query);
    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }
}
