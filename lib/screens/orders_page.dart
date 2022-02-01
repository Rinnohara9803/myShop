import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart' show Orders;
import 'package:myshop/widgets/circular_progress_indicator.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:myshop/widgets/order_item.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  static const routeName = '/orders_page';

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(
          key: UniqueKey(),
        ),
        appBar: AppBar(
          title: const Text('My Orders'),
        ),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).getOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const BlueGrayProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) {
                  if (orderData.orderItems.isNotEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await orderData.getOrders();
                      },
                      child: ListView.builder(
                        itemCount: orderData.orderItems.length,
                        itemBuilder: (ctx, i) {
                          return OrderItemm(orderData.orderItems[i]);
                        },
                      ),
                    );
                  }
                  return const Center(
                    child: Text('No orders placed.'),
                  );
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
