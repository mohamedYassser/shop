import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  const OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: ExpansionTile(
          title: Text('\$${order.amount}'),
          subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
          children: order.products
              .map((produc) => Row(
                    children: [
                      Text(
                        produc.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),SizedBox(width: 30,),
                      Text(
                        '${produc.quntity} * \$${produc.price}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber),
                      ),
                    ],
                  ))
              .toList(),
        ));
  }
}
