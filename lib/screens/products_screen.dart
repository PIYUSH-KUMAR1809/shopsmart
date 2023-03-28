import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/product_provider.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final List<Product> products = [];
  bool _showOnlyFavs = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
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
        title: const Text('ShopSmart'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedvalue) {
                setState(() {
                  if (selectedvalue == FilterOptions.Favourites) {
                    _showOnlyFavs = true;
                  } else {
                    _showOnlyFavs = false;
                  }
                });
              },
              itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: FilterOptions.Favourites,
                        child: Text('Only Favourites')),
                    PopupMenuItem(
                        value: FilterOptions.All, child: Text('Show All')),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badgee(
              value: cart.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavs),
    );
  }
}
