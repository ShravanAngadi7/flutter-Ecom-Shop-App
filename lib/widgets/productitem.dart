import 'package:ecom_shop_app/providers/Auth.dart';
import 'package:ecom_shop_app/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/products_details_screen.dart';
import '../providers/Product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // //final double price;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  //   //this.price,
  //   // this.price,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder: AssetImage('assests/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token.toString(),
                  authData.userId.toString(),
                );
              },
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
              color: Colors.amberAccent[700],
              //color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.AddItem(
                product.id ?? '',
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('added item to Cart'),
                  duration: const Duration(
                    seconds: 4,
                  ),
                  action: SnackBarAction(
                    label: '\'UNDO\'',
                    onPressed: () {
                      cart.removesingleItem(product.id ?? '');
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
