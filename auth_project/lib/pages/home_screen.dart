import 'package:auth_project/pages/product_add_screen.dart';
import 'package:auth_project/providers/product_provider.dart';
import 'package:auth_project/widget/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      isLoading = true;
      Provider.of<ProductProvider>(context).initProducts().then((value) {
        setState(() {
          isLoading = false;
        });
      });
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isInit = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
          icon: const Icon(
            Icons.logout_rounded
          ),
        ),
        title: const Text('List Products'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: (product.allProducts.isEmpty)
      ? const Center(
          child: Text("No Data"),
      ) : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10
          ),
          itemBuilder: (ctx, i) => ProductItem(
            product.allProducts[i].id,
            product.allProducts[i].name,
            product.allProducts[i].price,
            product.allProducts[i].imgUrl,
          ),
          padding: const EdgeInsets.all(20),
          itemCount: product.allProducts.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context,
              AddProductScreen.routeName
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.add_rounded
        ),
      ),
    );
  }
}