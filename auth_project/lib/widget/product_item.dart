import 'package:auth_project/model/product.dart';
import 'package:auth_project/pages/product_edit_screen.dart';
import 'package:auth_project/providers/product_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {

  final String id, name, price, imgUrl;

  ProductItem(this.id, this.name, this.price, this.imgUrl);

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<ProductProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
          subtitle: Text(
            price,
            style: const TextStyle(
                color: Colors.white
            ),
          ),
          backgroundColor: Colors.amber.withOpacity(0.75),
          trailing: IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () {
              product.deleteProduct(id)
                  .then((response) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Product berhasil dihapus"),
                          duration: Duration(seconds: 1),
                      )
                    )
              });
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context,
                EditProductScreen.routeName,
                arguments: id
            );
          },
          child: Hero(
            tag: 'product_image_$id',
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover
                  )
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.network(
                "https://i0.wp.com/digitalhealthskills.com/wp-content/uploads/2022/11/3da39-no-user-image-icon-27.png?fit=500%2C500&ssl=1",
                fit: BoxFit.cover,
              )
            ),
          ),
        ),
      ),
    );
  }
}