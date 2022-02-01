import 'package:flutter/material.dart';

enum CartState {
  isAddedToCart,
  isRemovedFromcart,
}

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class CartItems with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get cartItems {
    return {..._items};
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach(
      (key, value) {
        total += value.price * value.quantity;
      },
    );
    return double.parse(
      total.toStringAsFixed(2),
    );
  }

  int get itemCount {
    // return _items.length;

    int x = 0;
    _items.forEach((key, value) {
      x += value.quantity;
    });
    return x;
  }

  void addCartItem(
      String productId, String title, double price, String imageUrl) async {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: double.parse(
            value.price.toStringAsFixed(2),
          ),
          quantity: value.quantity + 1,
          imageUrl: value.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeCartItem(String productId) {
    // try {
    //   await http.delete()
    // } catch (e) {}
    _items.remove(productId);
    notifyListeners();
  }

  Future<void> editSingleCartItem(
      String productId, double price, int quantity) async {
    // try {

    // } catch (e) {
    //   rethrow;
    // }

    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items.containsKey(productId) && quantity > 0) {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: price,
            quantity: quantity,
            imageUrl: value.imageUrl),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeSingleCartItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity - 1,
          imageUrl: value.imageUrl,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
