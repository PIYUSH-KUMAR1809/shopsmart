import 'package:flutter/material.dart';
import 'package:shopsmart/providers/cart.dart';
import './screens/products_screen.dart';
import './screens/product_details.dart';
import './providers/product_provider.dart';
import 'package:provider/provider.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
      create: (context) => Products(),),
      ChangeNotifierProvider(
      create: (context) => Cart(),),
      ChangeNotifierProvider(
      create: (context) => Orders(),),
    ],
      child: MaterialApp(
        title: 'ShopSmart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Poppins',
        ),
        home: ProductScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          EditProductScreen.routeName:(context) => EditProductScreen(), 
        },
      ),
    );
  }
}

