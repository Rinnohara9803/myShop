import 'dart:math';

import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black26,
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 20.0,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 94.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.orange[300],
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black38,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: const Text(
              'MyShop',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 50,
                fontFamily: 'Anton',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
