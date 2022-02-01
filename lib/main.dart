import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/orders.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/add_user_product_page.dart';
import 'package:myshop/screens/auth_page.dart';
import 'package:myshop/screens/cart_page.dart';
import 'package:myshop/screens/edit_user_product_page.dart';
import 'package:myshop/screens/orders_page.dart';
import 'package:myshop/screens/product_details_page.dart';
import 'package:myshop/screens/product_overview_page.dart';
import 'package:myshop/screens/user_products_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(
            '',
            [],
          ),
          update: (ctx, auth, previousProducts) => Products(
              auth.token.toString(),
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(
            '',
            [],
          ),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token.toString(),
            previousOrders == null ? [] : previousOrders.orderItems,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartItems(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              fontFamily: 'Lato',
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: auth.isAuth ? '/' : AuthPage.routeName,
            routes: {
              '/': (ctx) => const ProductOverview(),
              AuthPage.routeName: (ctx) => AuthPage(),
              ProductDetailPage.routeName: (ctx) => const ProductDetailPage(),
              CartPage.routeName: (ctx) => const CartPage(),
              OrdersPage.routeName: (ctx) => const OrdersPage(),
              UserProductpage.routeName: (ctx) => const UserProductpage(),
              EditUserProductPage.routeName: (ctx) =>
                  const EditUserProductPage(),
              AddUserProductPage.routeName: (ctx) => const AddUserProductPage(),
            },
          );
        },
      ),
    );
  }
}
