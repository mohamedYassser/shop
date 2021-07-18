import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart.dart';
import 'dart:convert';

class OrderItem {
  final String id;

  final double amount;

  final int quntity;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem(
      {@required this.id,
      @required this.amount,
      this.quntity,
      @required this.dateTime,
      @required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authTOken;
  String userId;

  getData(String authTok, String useId, List<OrderItem> orders) {
    authTOken = authTok;
    userId = useId;
    _orders = orders;
    notifyListeners();
  }

//ققط استدعاء list _item

  List<OrderItem> get orders {
    return [..._orders];
  }

// الوصول لل العنصر المفضل
  //جلب البيا

  Future<void> fetchAndSetOrders() async {
//استدامuserId لجلب بياناتى فقط
    final url =
        'https://shop-3ad03-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authTOken';

    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quntity: item['quantity'],
                  price: item['price']))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://shop-3ad03-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authTOken';
    try {
      final dateStamp = DateTime.now();
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': dateStamp.toIso8601String(),
            'products': cartProduct
                .map((capo) => {
                      'id': capo.id,
                      'title': capo.title,
                      'quantity': capo.quntity,
                      'price': capo.price,
                    })
                .toList(),
          }));
      //ورز فى البدايهضافة الا
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            dateTime: dateStamp,
            products: cartProduct,
          ));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
