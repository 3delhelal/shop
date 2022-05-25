import 'package:flutter/material.dart';
import '../other/models.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, CartItem value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int addItem(String productId, String imageUrl, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                itemId: productId,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
                imageUrl: existingCartItem.imageUrl,
              ));
      notifyListeners();

      return _items[productId]!.quantity;
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            itemId: productId,
            title: title,
            imageUrl: imageUrl,
            quantity: 1,
            price: price),
      );
      notifyListeners();
      return 1;
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                itemId: existingCartItem.itemId,
                imageUrl: existingCartItem.imageUrl,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
