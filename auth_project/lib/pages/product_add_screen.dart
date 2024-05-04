import 'package:auth_project/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatelessWidget {

  static const routeName = '/add-product-screen';

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<ProductProvider>(context, listen: false);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
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
                    product.addProduct(
                        nameController.text,
                        priceController.text,
                        imageUrlController.text
                    ).then((response) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Product berhasil ditambahkan"),
                            duration: Duration(seconds: 1)
                          )
                      );
                      Navigator.pop(context);
                    }
                    );
                  },
                  child: const Text(
                    "Add Product"
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}