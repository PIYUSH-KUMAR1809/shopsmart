import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final int quantity;
  final double price;
  final String title;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productID, String title, double price) {
    if (_items.containsKey(productID)) {
      _items.update(
          productID,
          (existingCardItem) => CartItem(
                id: existingCardItem.id,
                price: existingCardItem.price,
                title: existingCardItem.title,
                quantity: existingCardItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
        productID,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }
    if (_items[productID]!.quantity > 1) {
      _items.update(
          productID,
          (existingCardItem) => CartItem(
                id: existingCardItem.id,
                price: existingCardItem.price,
                title: existingCardItem.title,
                quantity: existingCardItem.quantity + 1,
              ));
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
