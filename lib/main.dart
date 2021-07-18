import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';

import 'package:shop/providers/products.dart';
import 'package:shop/screens/auth.screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit__product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';

import 'package:shop/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //provider listener
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth,Products>(
            create: (_)=>Products(),
            update: (ctx,authValue,previousProducts)=>previousProducts..getData(authValue.token, authValue.userId, previousProducts==null?null:previousProducts.items),),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth,Orders>(create: (_)=>Orders(),
            update: (ctx,authValue,previousOrders)=>previousOrders..getData(authValue.token,
                authValue.userId,
                previousOrders==null?null:previousOrders.orders),),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.pink,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx,AsyncSnapshot snapshot)=>snapshot.connectionState== ConnectionState.waiting?SplashScreen():AuthScreen(),

                  ),
        //routeName..
        routes: {
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routName: (_) => CartScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
          EditProductScreen.routeName: (_) => EditProductScreen(),
          UserProductsScreen.routeName: (_) => UserProductsScreen(),
        },
      ),
    ));
  }
}
