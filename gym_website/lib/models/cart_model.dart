import 'package:flutter/foundation.dart';

// Simple carrito global (mini-estado):
class CartItem {
  final String id;
  final String title;
  final String subtitle;
  final int price; // en COP, sin separadores
  int qty;
  final String imageUrl;
  CartItem({required this.id, required this.title, required this.subtitle, required this.price, this.qty = 1, required this.imageUrl});
}
class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  List<CartItem> get items => _items.values.toList();
  int get total => _items.values.fold(0, (s, it) => s + it.price * it.qty);
  int get count => _items.values.fold(0, (s, it) => s + it.qty);
  void add(CartItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.qty += 1;
    } else {
      _items[item.id] = item;
    }
    notifyListeners();
  }
  void remove(String id) {
    _items.remove(id);
    notifyListeners();
  }
  void changeQty(String id, int delta) {
    if (!_items.containsKey(id)) return;
    _items[id]!.qty += delta;
    if (_items[id]!.qty <= 0) _items.remove(id);
    notifyListeners();
  }
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
final CartModel cart = CartModel();
