import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myshop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  String? get token {
    if (_token != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return _token != null;
  }

  //authenticates the users based two conditions namely: login and signup
  Future<void> authenticate(
      String email, String password, String webPath) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$webPath?key=AIzaSyBw-sZ-ty3-AxSbHgm2xf98MbsEUt4qV5A';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final jsonData = json.decode(response.body);
      if (jsonData['error'] != null) {
        throw HttpException(jsonData['error']['message']);
      }
      _token = jsonData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            jsonData['expiresIn'],
          ),
        ),
      );
      _userId = jsonData['localId'];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUpUser(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signInUser(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }
}
