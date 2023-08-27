import 'package:flutter/foundation.dart';

import '../Utils/Product.dart';

class Cart with ChangeNotifier {
  Map<Product, int> _items = {};

  Map<Product, int> get items => {..._items};

  int get itemCount => _items.length;

  void addItem(Product product) {

    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  getApiUrl() {
    return "http://13.233.204.99:8080/";
    // return "http://localhost:8080/";
  }
}
