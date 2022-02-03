import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class OrderItemm extends StatefulWidget {
  // const OrderItem({Key? key}) : super(key: key);
  final OrderItem order;

  OrderItemm(this.order);

  @override
  State<OrderItemm> createState() => _OrderItemmState();
}

class _OrderItemmState extends State<OrderItemm> {
  bool isLoading = false;
  bool isExpanded = false;

  Future<void> deleteOrder() async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Are you Sure?'),
          content: const Text(
            'Do you want to remove the order?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false)
                    .deleteOrder(widget.order.id)
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                }).catchError(
                  (e) {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('An error occurred!'),
                          content: const Text(
                            'Something went wrong.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Okay'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Column(
          children: [
            ListTile(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
              ),
              title: Text('Rs. ${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy   hh:mm:ss')
                    .format(widget.order.dateTime),
              ),
              trailing: IconButton(
                color: Colors.red.withOpacity(0.6),
                onPressed: () {
                  deleteOrder();
                },
                icon: isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.delete,
                      ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeIn,
              height: isExpanded
                  ? min(
                      widget.order.products.length * 20.0 + 50,
                      200,
                    )
                  : 0,
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order.products[i].title +
                              '  ( ${widget.order.products[i].quantity}X )',
                        ),
                        Text(
                          ' ${widget.order.products[i].price * widget.order.products[i].quantity.toDouble()}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
