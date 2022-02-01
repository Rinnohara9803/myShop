import 'package:flutter/material.dart';
import 'package:myshop/models/http_exception.dart';
import 'package:myshop/providers/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  Products(this.authToken, this._items);

  List<Product> _items = [];

  var showFavourites = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Product getById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product newProduct) async {
    final url =
        'https://flutterupdate-63805-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavourite': newProduct.isFavourite,
          },
        ),
      );
      _items.insert(
        0,
        Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl,
        ),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getProducts() async {
    final url =
        'https://flutterupdate-63805-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';

    http.Response response;
    try {
      response = await http.get(
        Uri.parse(url),
      );
    } catch (e) {
      throw HttpException('No internet.');
    }
    if (jsonDecode(response.body) == null) {
      return;
    } else if (response.body.isNotEmpty && response.statusCode == 200) {
      var jsonData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> _loadedProducts = [];

      jsonData.forEach(
        (key, value) {
          _loadedProducts.add(
            Product(
              id: key,
              title: value['title'] as String,
              description: value['description'] as String,
              price: double.parse(
                value['price'].toString(),
              ),
              imageUrl: value['imageUrl'] as String,
              isFavourite: value['isFavourite'] as bool,
            ),
          );
        },
      );
      _items = _loadedProducts;
      notifyListeners();
    }
  }

  Future<void> editProduct(String id, Product theProduct) async {
    // int index = _items.indexWhere((product) => product.id == id);
    final url =
        'https://flutterupdate-63805-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';

    Product tbrProduct = _items.firstWhere((product) => product.id == id);
    int index = _items.indexOf(tbrProduct);

    try {
      if (index >= 0) {
        await http.patch(
          Uri.parse(url),
          body: jsonEncode(
            {
              'title': theProduct.title,
              'description': theProduct.description,
              'imageUrl': theProduct.imageUrl,
              'price': theProduct.price,
              'isFavourite': theProduct.isFavourite,
            },
          ),
        );
        _items[index] = theProduct;
        notifyListeners();
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutterupdate-63805-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
    try {
      await http.delete(
        Uri.parse(url),
      );
    } catch (e) {
      rethrow;
    }
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
