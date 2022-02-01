import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/add_user_product_page.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:myshop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductpage extends StatelessWidget {
  const UserProductpage({Key? key}) : super(key: key);

  static const routeName = '/user_product_page';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = productData.items;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your Products',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AddUserProductPage.routeName,
                );
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        drawer: AppDrawer(
          key: UniqueKey(),
        ),
        body: products.isEmpty
            ? const Center(
                child: Text('No products to show'),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<Products>(context, listen: false)
                      .getProducts()
                      .catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No internet connection',
                        ),
                      ),
                    );
                  });
                },
                child: ListView.builder(
                  itemCount: productData.items.length,
                  itemBuilder: (ctx, i) {
                    return UserProductItem(
                      productData.items[i].title,
                      productData.items[i].imageUrl,
                      productData.items[i].id,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
