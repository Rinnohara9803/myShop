import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myshop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  String? get userId {
    return _userId;
  }

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
      autoLogout();
      notifyListeners();
      final prefs0 = await SharedPreferences.getInstance();
      prefs0.setString('token', _token!);
      prefs0.setString('userId', _userId!);
      prefs0.setString(
        'expiryDate',
        _expiryDate!.toIso8601String(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs0 = await SharedPreferences.getInstance();

    final expiryDate = DateTime.parse(prefs0.getString('expiryDate')!);

    if (!prefs0.containsKey('token')) {
      return false;
    } else if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = prefs0.getString('token');
    _userId = prefs0.getString('userId');
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signUpUser(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signInUser(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs0 = await SharedPreferences.getInstance();
    prefs0.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timerDuration = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timerDuration), logout);
  }
}
