import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/favourite_icon.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  static const routeName = '/productDetails';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<Products>(context, listen: true).getById(id);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shop'),
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              height: height,
              width: width,
              child: Column(
                children: [
                  Flexible(
                    child: Container(),
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                            20,
                          ),
                          topRight: Radius.circular(
                            20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: width * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                child: SizedBox(
                  height: height * 0.4,
                  width: width * 0.7,
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
              ),
            ),
            ChangeNotifierProvider.value(
              value: product,
              child: const FavouriteIconWidget(),
            ),
            Positioned(
              left: 20,
              top: height * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Price: Rs. ${product.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
