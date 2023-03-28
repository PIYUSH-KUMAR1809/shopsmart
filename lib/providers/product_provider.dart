import 'package:flutter/foundation.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> get favitems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Product FindbyID(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
      'https://shopsmart-bc5ee-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString',
    );
    var url2 = Uri.parse(
      'https://shopsmart-bc5ee-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourites/$userId.json?auth=$authToken',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //print('hello');
      //log(extractedData.toString());
      if (extractedData == null) {
        return;
      }
      final favResponse = await http.get(
        url2,
      );
      final favData = json.decode(favResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        // print(prodData);
        loadedProducts.add(Product(
          id: prodId,
          isFavourite: favData == null ? false : favData[prodId] ?? false,
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          title: prodData['title'],
        ));
        _items = loadedProducts;
        notifyListeners();
      });
      if (kDebugMode) {
        print(response);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> addItem(Product product) async {
    var url = Uri.parse(
      'https://shopsmart-bc5ee-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://shopsmart-bc5ee-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken',
      );
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('Error UpdateProduct()');
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://shopsmart-bc5ee-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken',
    );
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
