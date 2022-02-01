import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/cart_page.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:myshop/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

enum Filters {
  allProducts,
  favourites,
}

class ProductOverview extends StatefulWidget {
  const ProductOverview({Key? key}) : super(key: key);

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool showFavourites = false;

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartItems>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shop'),
          actions: [
            PopupMenuButton(
              onSelected: (Filters selectedValue) {
                setState(() {
                  if (selectedValue == Filters.favourites) {
                    showFavourites = true;
                  } else {
                    showFavourites = false;
                  }
                });
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: Filters.favourites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: Filters.allProducts,
                ),
              ],
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 5,
              ),
              child: Consumer<CartItems>(
                builder: (_, cartItem, child) => Badge(
                  child: child as Widget,
                  value: cartData.itemCount.toString(),
                  color: Colors.amber,
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_sharp),
                  onPressed: () {
                    Navigator.pushNamed(context, CartPage.routeName);
                  },
                ),
              ),
            ),
          ],
        ),
        drawer: AppDrawer(
          key: UniqueKey(),
        ),
        body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false).getProducts(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 4,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    period: const Duration(
                      milliseconds: 1500,
                    ),
                    baseColor: Colors.blueGrey,
                    highlightColor: Colors.white,
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(
                                  10,
                                ),
                                topLeft: Radius.circular(
                                  10,
                                ),
                              ),
                              child: Container(
                                color: Colors.black12,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(
                                  10,
                                ),
                                bottomLeft: Radius.circular(
                                  10,
                                ),
                              ),
                              child: Container(
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.error.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text('Check your Connection.'),
                    const Text('And'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<Products>(
                builder: (ctx, productData, child) {
                  if (productData.items.isNotEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await productData.getProducts();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ProductsGrid(showFavourites),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No Items Found.'),
                    );
                  }
                },
              );
            } else {
              return const Center(
                child: Text('Something went wrong.'),
              );
            }
          },
        ),
      ),
    );
  }
}
