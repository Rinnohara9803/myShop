import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/screens/product_details_page.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartData = Provider.of<CartItems>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        10,
      ),
      child: GridTile(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductDetailPage.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: 'rino9803 ${product.id}',
            child: Image(
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (context, product, child) {
              return IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Colors.amber,
                onPressed: () {
                  product.toggleToIsFavourite(
                    authData.token.toString(),
                    authData.userId.toString(),
                  );
                },
              );
            },
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.amber,
            ),
            onPressed: () {
              cartData.addCartItem(
                product.id,
                product.title,
                product.price,
                product.imageUrl,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueGrey,
                  content: const Text('Item added to the Cart'),
                  duration: const Duration(
                    milliseconds: 1500,
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.amber,
                    onPressed: () {
                      cartData.removeSingleCartItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
