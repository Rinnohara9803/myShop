import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/screens/orders_page.dart';
import 'package:myshop/screens/user_products_page.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(
              Icons.shop,
            ),
            title: const Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/',
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart,
            ),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                OrdersPage.routeName,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
            ),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                UserProductpage.routeName,
              );
            },
          ),
          const Divider(),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
