import 'package:flutter/material.dart';
import 'models.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
        0, (total, item) => total + item.product.price * item.quantity);
  }

  void addToCart(Product product) {
    bool isExisting = false;
    for (var item in _items) {
      if (item.product.name == product.name) {
        item.quantity++;
        isExisting = true;
        break;
      }
    }
    if (!isExisting) {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }
}

class Favorites with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  void addToFavorites(Product product) {
    if (!_items.contains(product)) {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeFromFavorites(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _items.contains(product);
  }
}
