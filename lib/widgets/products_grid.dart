import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  ProductsGrid(this.showFavourites);
  final bool showFavourites;
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final theItems =
        !showFavourites ? productsData.items : productsData.favItems;

    return GridView.builder(
      padding: const EdgeInsets.all(
        5,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        childAspectRatio: 4 / 4,
      ),
      itemCount: theItems.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: theItems[index],
          child: ProductItem(),
        );
      },
    );
  }
}
