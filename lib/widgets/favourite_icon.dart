import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';
import 'package:provider/provider.dart';

class FavouriteIconWidget extends StatelessWidget {
  const FavouriteIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return Positioned(
      top: 10,
      right: 10,
      child: IconButton(
        onPressed: () {
          product.toggleToIsFavourite();
        },
        icon: Consumer<Product>(
          builder: (ctx, product, child) => Icon(
            product.isFavourite
                ? Icons.favorite_rounded
                : Icons.favorite_outline_rounded,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
