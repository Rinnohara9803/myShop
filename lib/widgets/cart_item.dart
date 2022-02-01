import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  // const CartItem({Key? key}) : super(key: key);

  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem(
    this.id,
    this.productId,
    this.title,
    this.imageUrl,
    this.quantity,
    this.price,
  );

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Widget editButtons(Function onPressed, String text, Color color) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            color,
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(text),
      ),
    );
  }

  Widget quantityChangingButtons(Function onPressed, IconData icon) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(
            5,
          ),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget dismissableBackgrounds(
    Color color,
    IconData icon,
    AlignmentGeometry alignment,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      padding: alignment == Alignment.centerLeft
          ? const EdgeInsets.only(
              left: 20,
            )
          : const EdgeInsets.only(
              right: 20,
            ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: color,
      ),
      alignment: alignment,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Future<bool> returnFalse() async {
    return false;
  }

  int quantity = 0;
  double price = 0.0;

  @override
  void initState() {
    quantity = widget.quantity;
    price = widget.price * quantity;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartItems>(
      context,
      listen: false,
    );

    return Dismissible(
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Are you Sure?'),
                content: const Text(
                  'Do you want to remove the item from the Cart?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) {
              return StatefulBuilder(
                builder: (ctx, StateSetter setState) {
                  return Dialog(
                    elevation: 2,
                    backgroundColor: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 72,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                  widget.imageUrl,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${widget.title} ( Rs. ${widget.price} )',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                quantityChangingButtons(() {
                                  if (quantity == 0) {
                                    return;
                                  } else if (quantity == 1) {
                                    setState(() {
                                      quantity--;
                                      price = 0.0;
                                    });
                                    return;
                                  }
                                  setState(() {
                                    quantity--;
                                    price -= widget.price;
                                  });
                                }, Icons.remove),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                quantityChangingButtons(
                                  () {
                                    setState(() {
                                      quantity++;
                                      price += widget.price;
                                    });
                                  },
                                  Icons.add,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rs. ' + price.toStringAsFixed(2),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    editButtons(
                                      () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          price = widget.price;
                                          quantity = widget.quantity;
                                        });
                                      },
                                      'Cancel',
                                      Colors.redAccent,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    editButtons(
                                      () {
                                        Provider.of<CartItems>(context,
                                                listen: false)
                                            .editSingleCartItem(
                                          widget.productId,
                                          widget.price,
                                          quantity,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      'Save Changes',
                                      Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
          return returnFalse();
        }
      },
      key: UniqueKey(),
      secondaryBackground: dismissableBackgrounds(
        Colors.redAccent.withOpacity(0.8),
        Icons.delete,
        Alignment.centerRight,
      ),
      background: dismissableBackgrounds(
        Theme.of(context).primaryColor,
        Icons.edit,
        Alignment.centerLeft,
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          return cartData.removeCartItem(widget.productId);
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            8,
          ),
          child: ListTile(
            dense: true,
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              height: 60,
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                child: Image(
                  image: NetworkImage(
                    widget.imageUrl,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Row(
              children: [
                Text(
                  widget.title,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '( Rs. ${widget.price} )',
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Total: Rs. ${(widget.price * widget.quantity).toStringAsFixed(2)}',
            ),
            trailing: Text('${widget.quantity} X'),
          ),
        ),
      ),
    );
  }
}
