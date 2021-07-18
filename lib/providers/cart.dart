import 'package:flutter/material.dart';

class CartItem {
  final String id;

  final String title;

  final int quntity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quntity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quntity;
    });
    return total;
  } //اضافة لو كان فى prodid

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (exitingCartItem) => CartItem(
                id: exitingCartItem.id,
                title: exitingCartItem.title,
                price: exitingCartItem.price,
                quntity: exitingCartItem.quntity + 1,
              ));
    } else {
      //اضافة من العدم
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quntity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

//حزف منتج واحد
  void removeSigleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quntity > 1) {
      _items.update(
          productId,
          (exitingCartItem) => CartItem(
                id: exitingCartItem.id,
                title: exitingCartItem.title,
                price: exitingCartItem.price,
                quntity: exitingCartItem.quntity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
