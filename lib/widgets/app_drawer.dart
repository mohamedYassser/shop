import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text('lol'),automaticallyImplyLeading: false,),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),

            title: Text('Shop'),
            onTap: () => Navigator.of(context).popAndPushNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () =>
                Navigator.of(context).popAndPushNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage products'),
            onTap: () => Navigator.of(context)
                .popAndPushNamed(UserProductsScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .popAndPushNamed('/');
              Provider.of<Auth>(context,listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
