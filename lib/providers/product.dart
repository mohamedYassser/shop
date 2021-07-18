import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavo;

  Product({
  @required  this.id,
   @required this.title,
   @required this.description,
    @required this.price,
  @required  this.imageUrl,
this.isFavo = false,
  });

  void _setFavo (bool newVal){

    isFavo = newVal ;
    notifyListeners();

  }

  Future <void> togleFavo(String token ,String userId)async{


final  oldSfavo = isFavo ;
isFavo =!isFavo;
notifyListeners();

final url ='https://shop-3ad03-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
try{
  //لتعديل فقط على محتوى واحد
  final respons =await http.put(url,body:json.encode(isFavo));
  if(respons.statusCode >= 400){
    _setFavo(oldSfavo);
  }
    }catch (e){
    _setFavo(oldSfavo);
    }
  }
}
