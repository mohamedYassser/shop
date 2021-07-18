import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/oredr_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Order")),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text("An error occurred!"));

            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (BuildContext context, int index) =>
                      OrderItem(orderData.orders[index],
                      ),

                ),
              );
            }
          }
        },
      ),
    );
  }
}
