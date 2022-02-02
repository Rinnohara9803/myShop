import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

class AddUserProductPage extends StatefulWidget {
  const AddUserProductPage({Key? key}) : super(key: key);

  static const routeName = '/add_user_product_page';

  @override
  _AddUserProductPageState createState() => _AddUserProductPageState();
}

class _AddUserProductPageState extends State<AddUserProductPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  bool isLoading = false;
  bool hasErrors = false;

  final _formKey = GlobalKey<FormState>();

  var editedProduct = Product(
    id: DateTime.now().toString(),
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  Future<void> _saveForm(Products product) async {
    final isValidated = _formKey.currentState!.validate();
    if (!isValidated) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Products>(context, listen: false)
          .addProduct(editedProduct);
    } catch (e) {
      setState(() {
        hasErrors = true;
      });
      await showDialog(
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
    } finally {
      setState(() {
        isLoading = false;
      });
      if (hasErrors == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully.'),
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(
        () {},
      );
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  // void dispose() {
  // _priceFocusNode.dispose();
  // _descriptionFocusNode.dispose();
  // _imageUrlFocusNode.dispose();
  // _imageUrlController.dispose();
  // _imageUrlFocusNode.removeListener(_updateImageUrl);
  // super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      title: value as String,
                      description: editedProduct.description,
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please provide a title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  focusNode: _priceFocusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: editedProduct.description,
                      price: double.parse(value as String),
                      imageUrl: editedProduct.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a Price.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'please provide a valid Number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'please enter a Greater Number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  focusNode: _descriptionFocusNode,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: value as String,
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please provide a Description.';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Center(
                              child: Text('No Url Provided'),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              child: Image(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  _imageUrlController.text,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(),
                        ),
                        controller: _imageUrlController,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (value) {
                          setState(
                            () {
                              _imageUrlController.text = value;
                            },
                          );
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            imageUrl: value as String,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide an Image URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please provide a valid Image URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg') &&
                              !value.endsWith('.gif')) {
                            return 'Please provide a valid Image URL';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveForm(productData);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Add',
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
