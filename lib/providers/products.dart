import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  String authTOken;

  String userId;

//للوصول للبيايانت القديمه حتى لا نفقدهها
  getData(String authTok, String  useId, List<Product> products) {
    authTOken = authTok;
    userId = useId;
    _items = products;
    notifyListeners();
  }

//  عشان انا ععرف استدعيها عشان عملتها برايفت ققط استدعاء list _item

  List<Product> get items {
    return [..._items];
  }

// الوصول لل العنصر المفضل
  List<Product> get favoritesItems {
    return _items.where((productIem) => productIem.isFavo).toList();
  }
  //العنصر الزى يطابق id

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //جلب البيا
  // fileter by user
  //جلب البانات مره بشكل عام كل المنتجات ومره للمفضله فقط
  Future<void> fetchAndSetData([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy= "creatorId"&equalTo ="$userId"' : '';
    var url =
        'https://shop-3ad03-default-rtdb.firebaseio.com/Products.json?auth=$authTOken&$filterString';

    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-3ad03-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authTOken';
      final favRes = await http.get(url);
      final favData = json.decode(favRes.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          isFavo: favData == null ? false : favData[productId] ?? false,
          imageUrl: productData['imageUrl'],
        ));
      });

    _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  // اضافى البيانات اللفايربيز والموبايل
  Future<void> addProd(Product product) async {
    final url = 'https://shop-3ad03-default-rtdb.firebaseio.com/products.json?auth=$authTOken';
    try {
      final res = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final newProd = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProd);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateDta(String id, Product newProd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-3ad03-default-rtdb.firebaseio.com/products/$id.json?auth=$authTOken';
      await http.patch(url,
          body: json.encode({
            'title': newProd.title,
            'description': newProd.description,
            'imageUrl': newProd.imageUrl,
            'price': newProd.price,
          }));
      _items[prodIndex] = newProd;
      notifyListeners();
    } else {
      print("....");
    }
  }

  Future<void> deletProduct(String id) async {
    final url =
        'https://shop-3ad03-default-rtdb.firebaseio.com/products/$id.json?auth=$authTOken';
    final exaitingProdIndex = _items.indexWhere((prod) => prod.id == id);
    var exiteProd = _items[exaitingProdIndex];
    _items.removeAt(exaitingProdIndex);
    notifyListeners();
    //فلى حالة وجوود حطا اكبر من 400
    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(exaitingProdIndex, exiteProd);
      notifyListeners();

      throw HttpException("cloud not delete product");
    }

    exiteProd = null;
  }
}
