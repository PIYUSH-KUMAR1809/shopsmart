import 'package:flutter/material.dart';
import 'package:shopsmart/providers/cart.dart';
import './screens/products_screen.dart';
import './screens/splash_screen.dart';
import './screens/product_details.dart';
import './providers/product_provider.dart';
import 'package:provider/provider.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (context, auth, previousProducts) => Products(
              auth.token.toString(),
              auth.userId.toString(),
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', '', []),
          update: (context, auth, previousOrders) => Orders(
              auth.token.toString(),
              auth.userId.toString(),
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'ShopSmart',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Poppins',
          ),
          home: auth.isAuth
              ? const ProductScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
