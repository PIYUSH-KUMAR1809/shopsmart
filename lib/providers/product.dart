import 'package:flutter/material.dart';

class Product with ChangeNotifier{
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

    void toggleIsFavourite()
    {
      isFavourite = !isFavourite;
      notifyListeners();
    }
}
