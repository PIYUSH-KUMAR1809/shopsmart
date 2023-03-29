import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).FindbyID(productID);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title.toString()),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.65,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Container(
                  width: MediaQuery.of(context).size.width * 0.43,
                  color: Colors.blue,
                  child: Text(
                    loadedProduct.title.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              Text(
                '\$${loadedProduct.price}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description.toString(),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
