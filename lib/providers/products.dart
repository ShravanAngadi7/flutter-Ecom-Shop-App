import 'package:ecom_shop_app/model/http.dart';
import 'package:http/http.dart' as http;
import 'Product.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Products extends ChangeNotifier {
  // ignore: prefer_final_fields
  late List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     title: 'Sneakers',
    //     description: 'Best collection of stocks',
    //     price: 29.9,
    //     imageUrl:
    //         'https://i.pinimg.com/originals/5d/d7/2c/5dd72c11dc04435305abaf59afed60ec.jpg'),
    // Product(
    //     id: 'p2',
    //     title: 'Sliders',
    //     description: 'prefect one to wear',
    //     price: 25.9,
    //     imageUrl:
    //         'https://images.bewakoof.com/t640/women-s-pink-sliders-468467-1656166006-1.jpg'),
    // Product(
    //     id: 'p3',
    //     title: 'Sandals',
    //     description: 'flexible and stretchable',
    //     price: 14.9,
    //     imageUrl:
    //         'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/64d54bbd-0fa3-4201-bf8e-0bb302e83f76/vista-sandals-1rGmxQ.png'),
    // Product(
    //     id: 'p4',
    //     title: 'Croc\'s',
    //     description: 'tight and comfort',
    //     price: 23.9,
    //     imageUrl:
    //         'https://m.media-amazon.com/images/I/6159VAHL3NL._UL1320_.jpg'),
  ];

  // List _cartItems = [];

  // get cartItems => _cartItems;
  // get items => _items;

  // var _showsFavoritesOnly = false;
  String? authToken = '';
  String? userId = '';
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showsFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  get addimage => null;

  // void showFavoritesOnly() {
  //   _showsFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showsFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchandSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId' : '';
    var url = Uri.parse(
        'https://flutter-shop-app-c2494-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      url = Uri.parse(
          'https://flutter-shop-app-c2494-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteresponse = await http.get(url);
      final favoriteData = jsonDecode(favoriteresponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-app-c2494-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'creatorId': userId,
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          //'isFavorite': product.isFavorite,
          // 'creatorId': userId,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
    // return Future.value();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-shop-app-c2494-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-app-c2494-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    existingProduct = null!;
  }

  // List _CartItems = [];

  // get cartItems => _CartItems;

  // get shopItems => _items;

  // void addItemtoCart(int index) {
  //   _CartItems.add(_items[index]);
  //   notifyListeners();
  // }

  // void removeItemFromCart(int index) {
  //   _CartItems.removeAt(index);
  //   notifyListeners();
  // }

  // String calculateTotal() {
  //   double totalPrice = 0;
  //   for (int i = 0; i < cartItems.length; i++) {
  //     totalPrice += double.parse(cartItems[i][1]);
  //   }
  //   return totalPrice.toStringAsFixed(3);
  // }
}
