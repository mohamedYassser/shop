import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(" Yu Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(14),
            child: Padding(
              padding: EdgeInsets.all(7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  //تعطى ليبل وحواف مدوره
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.headline6,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, int index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quntity,
                cart.items.values.toList()[index].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton({@required this.cart});

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isloding = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      // او toatalAmount ا,  isloding

      onPressed: (widget.cart.totalAmount <= 0 || _isloding)
          ? null
          : () async {
              setState(() {
                setState(() {
                  _isloding = true;
                });
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);

              widget.cart.clear();
              setState(() {
                _isloding = false;
              });
            },

      child: _isloding ? CircularProgressIndicator() : Text("ORDER NoW"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
