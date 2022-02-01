import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleToIsFavourite(String token) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;

    notifyListeners();
    final url =
        'https://flutterupdate-63805-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token';
    try {
      final response = await http.patch(
        Uri.parse(
          url,
        ),
        body: json.encode(
          {
            'isFavourite': isFavourite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
