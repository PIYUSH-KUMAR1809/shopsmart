import 'package:flutter/material.dart';
import 'package:shopsmart/screens/product_details.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context);
    var col = theme.colorScheme.secondary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: col,
              ),
              onPressed: () {
                product.toggleIsFavourite(
                    authData.token.toString(), authData.userId.toString());
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: col,
            ),
            onPressed: () {
              cart.addItem(product.id.toString(), product.title.toString(),
                  product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added item to cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id.toString());
                    },
                  ),
                ),
              );
            },
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
