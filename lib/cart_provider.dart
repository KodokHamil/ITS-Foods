import 'package:flutter/cupertino.dart';
import 'package:its_food/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_model.dart';

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  CartProvider() {
    _getPrefItems();
    _cart = getData();
  }

  Future<List<Cart>> getData() async {
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
    notifyListeners();
  }

  void addTotalPrice(double foodPrice) {
    _totalPrice += foodPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double foodPrice) {
    _totalPrice -= foodPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice() {
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    if (_counter > 0) {
      _counter--;
      _setPrefItems();
      notifyListeners();
    }
  }

  int getCounter() {
    return _counter;
  }

  void resetCounterAndTotal() {
    _counter = 0;
    _totalPrice = 0;
    _setPrefItems();
    notifyListeners();
  }
}
