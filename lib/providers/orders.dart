import 'package:flutter/material.dart';
import 'package:myshop/models/http_exception.dart';
import 'package:myshop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get orderItems {
    return [..._orderItems];
  }

  Future<void> addOrderItem(double amount, List<CartItem> products) async {
    const url =
        'https://flutterupdate-63805-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'totalAmount': amount,
            'dateTime': timeStamp.toIso8601String(),
            'products': products.map(
              (cartItem) {
                return {
                  'id': cartItem.id,
                  'title': cartItem.title,
                  'price': cartItem.price,
                  'quantity': cartItem.quantity,
                  'imageUrl': cartItem.imageUrl,
                };
              },
            ).toList(),
          },
        ),
      );
      _orderItems.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: amount,
          products: products,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getOrders() async {
    const url =
        'https://flutterupdate-63805-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json';

    http.Response response;

    try {
      response = await http.get(
        Uri.parse(url),
      );
    } catch (e) {
      throw HttpException('No Internet');
    }
    if (jsonDecode(response.body) == null) {
      return;
    } else {
      final jsonData =
          await json.decode(response.body) as Map<dynamic, dynamic>;

      List<OrderItem> _fetchedOrderItems = [];

      jsonData.forEach(
        (key, value) {
          _fetchedOrderItems.add(
            OrderItem(
              id: key,
              amount: double.parse(
                value['totalAmount'].toString(),
              ),
              products: (value['products'] as List<dynamic>).map(
                (cartItem) {
                  return CartItem(
                    id: cartItem['id'] as String,
                    title: cartItem['title'] as String,
                    price: double.parse(
                      cartItem['price'].toString(),
                    ),
                    quantity: int.parse(cartItem['quantity'].toString()),
                    imageUrl: cartItem['imageUrl'] as String,
                  );
                },
              ).toList(),
              dateTime: DateTime.parse(
                value['dateTime'],
              ),
            ),
          );
          _orderItems = _fetchedOrderItems;
          notifyListeners();
        },
      );
    }
  }

  Future<void> deleteOrder(String id) async {
    final url =
        'https://flutterupdate-63805-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$id.json';

    try {
      await http.delete(
        Uri.parse(url),
      );
    } catch (e) {
      rethrow;
    }
    OrderItem orderItem = _orderItems.firstWhere((order) => order.id == id);
    _orderItems.remove(orderItem);
    notifyListeners();
  }
}
