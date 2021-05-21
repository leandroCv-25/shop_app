import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http; 

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  void _setFavValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toogleFavoriteStatus()async{
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    
    final String url = "https://dysfirebase.firebaseio.com/products/$id.json";

    try{
      final response = await http.patch(url,body:json.encode({'isFavorite': isFavorite,}));
      if(response.statusCode>=400){
        _setFavValue(oldStatus);
      }
    } catch (error){
      _setFavValue(oldStatus);
    }

  }

  Product(
      {@required this.id,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      @required this.title,
      this.isFavorite=false});
}
