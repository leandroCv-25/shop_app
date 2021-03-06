//Dart
import 'dart:convert';
import 'dart:async';

//Flutter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Providers
import './product.dart';

//models
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  /*bool _showFavoritesOnly = false;

  List<Product> get items{
    if(_showFavoritesOnly){
      return _items.where((product)=>product.isFavorite).toList();
    }else{
      return [..._items];
    }
  }

  void showFavorites(){
    _showFavoritesOnly=true;
    notifyListeners();
  }

  void showAll(){
    _showFavoritesOnly=false;
    notifyListeners();
  }*/

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const String url = "https://dysfirebase.firebaseio.com/products.json";

    try {
      final response = await http.get(
        url,
      );
      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData ==null){
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            description: prodData["description"],
            title: prodData["title"],
            price: prodData["price"],
            isFavorite: prodData["isFavorite"],
            imageUrl: prodData["imageUrl"]));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product editedProduct) async {
    const String url = "https://dysfirebase.firebaseio.com/products.json";
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': editedProduct.title,
            'description': editedProduct.description,
            'price': editedProduct.price,
            'imageUrl': editedProduct.imageUrl,
            'isFavorite': editedProduct.isFavorite,
          }));

      Product _newProduct = Product(
        title: editedProduct.title,
        description: editedProduct.description,
        price: editedProduct.price,
        imageUrl: editedProduct.imageUrl,
        isFavorite: editedProduct.isFavorite,
        id: json.decode(response.body)['name'],
      );
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final String url = "https://dysfirebase.firebaseio.com/products/$id.json";
      try {
        await http.patch(url,
            body: json.encode({
              "title": newProduct.title,
              "description": newProduct.description,
              "price": newProduct.price,
              "imageUrl": newProduct.imageUrl,
              //"isFavorite": newProduct.isFavorite
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final String url = "https://dysfirebase.firebaseio.com/products/$id.json";
    final int existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Coulnd not delete product.");
    }
    existingProduct = null;
  }
}
