import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_user_product_page.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatefulWidget {
  // const UserProductItem({Key? key}) : super(key: key);

  final String title;
  final String imageUrl;
  final String productId;

  UserProductItem(
    this.title,
    this.imageUrl,
    this.productId,
  );

  @override
  State<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  bool isLoading = false;
  bool hasErrors = false;

  Future<void> deleteProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(
        context,
        listen: false,
      ).deleteProduct(
        widget.productId,
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasErrors = true;
      });
    }
    if (hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        widget.imageUrl,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      EditUserProductPage.routeName,
                      arguments: widget.productId,
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteProduct();
                  },
                  icon: isLoading
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
