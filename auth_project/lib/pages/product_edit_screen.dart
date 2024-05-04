import 'package:auth_project/providers/product_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {

  static const routeName = '/product-edit-screen';

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<ProductProvider>(context, listen: false);
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedProduct = product.getProductById(productId);

    final TextEditingController nameController = TextEditingController(text: selectedProduct.name);
    final TextEditingController priceController = TextEditingController(text: selectedProduct.price);
    final TextEditingController imageUrlController = TextEditingController(text: selectedProduct.imgUrl);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Screen"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Hero(
                  tag: 'product_image_$productId',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: imageUrlController.text,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      )
                  ),
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Price",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      )
                  ),
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  controller: priceController,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Image Url",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      )
                  ),
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  controller: imageUrlController,
                ),
                const SizedBox(height: 20),
                FilledButton(
                    onPressed: () {
                      product.editProduct(
                          productId,
                          nameController.text,
                          priceController.text,
                          imageUrlController.text
                      ).then((response) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Product berhasil diubah"),
                                duration: Duration(seconds: 1)
                            )
                        );
                        Navigator.pop(context);
                      }
                      );
                    },
                    child: const Text(
                        "Edit Product"
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}