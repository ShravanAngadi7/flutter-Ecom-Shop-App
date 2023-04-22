import 'package:ecom_shop_app/screens/cartscreen.dart';
import 'package:ecom_shop_app/widgets/appdrawer.dart';
import '../widgets/badge.dart';
//import 'package:ecom_shop_app/widgets/badge (1).dart';
import 'package:flutter/material.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showsFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchandSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("My Shop Sia"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showsFavoritesOnly = true;
                } else {
                  _showsFavoritesOnly = false;
                }
              });
            },
            icon: const Icon(Icons.more_horiz_outlined),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOptions.Favorite,
              ),
              // ignore: prefer_const_constructors
              PopupMenuItem(
                child: const Text("Home Page"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, Cart, child) => Badgee(
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, Cartscreen.routeName);
                },
              ),
              value: Cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showsFavoritesOnly),
    );
  }
}
