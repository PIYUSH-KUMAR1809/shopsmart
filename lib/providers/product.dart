import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String description;
  final String title;
  final String imageUrl;
  final double price;
  bool isFavourite;
  Product({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.title,
    this.isFavourite = false,
  });

  void _setFavValue(bool newVal) {
    isFavourite = newVal;
    notifyListeners();
  }

  Future<void> toggleIsFavourite(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
      'https://shopsmart-bc5ee-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourites/$userId/$id.json?auth=$token',
    );
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        print('hello1');
        print('chsnged!');
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
