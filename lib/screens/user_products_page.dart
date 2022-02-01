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
    final productData = Provider.of<Products>(context, listen: false);
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
        body: products.isNotEmpty
            ? FutureBuilder(
                future: Provider.of<Products>(context, listen: false)
                    .getProducts(true),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('No Internet Connection.'),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await productData.getProducts(true);
                      },
                      child: Consumer<Products>(
                        builder: (ctx, productData, _) {
                          return ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (ctx, i) {
                              return UserProductItem(
                                productData.items[i].title,
                                productData.items[i].imageUrl,
                                productData.items[i].id,
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                })
            : const Center(
                child: Text('No products to show'),
              ),
      ),
    );
  }
}
